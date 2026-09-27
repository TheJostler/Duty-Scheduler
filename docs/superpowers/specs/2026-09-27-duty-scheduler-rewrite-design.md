# Duty scheduler: the rewrite for Vox 0.4.15

Status: design, 2026-09-27. Depends on vox-libs `date` 0.1 and `textkit`
0.2, designed in `vox-libs/docs/plans/315_date_and_textkit_0_2.md`.

## What it is for

A congregation has two meetings a week, midweek and weekend. Each needs an
attendant on the door and one in the auditorium. Someone has to hand out
those four duties a week across twenty-odd people, fairly, without giving a
duty to someone who has said they are away, and then publish the result as
a spreadsheet. This program does that from two text files and prints a
schedule a person can read, plus a CSV a spreadsheet can open.

The old program does this today and its output shape is right. It no
longer compiles, it is 600 lines of byte arithmetic that nobody can read,
and it has one real bug: it matches the availability grid to people by
column position, and the real grid's columns are in a different order from
the real names file, so the wrong people get blocked. The rewrite keeps the
job, keeps the files, and changes everything about how it is written.

## Decisions already taken

- Fairness scoring replaces circular rotation (owner's choice).
- Grid columns are matched to people by header name; mismatches warn.
- A names file line is a name, the whole line, as the old program reads it.
- The calendar and text splitting come from the public libraries, and the
  libraries know nothing about this program.

## Inputs

**The names file** (`-f`, default `names.txt`): one person per line, the
trimmed line being the name. Blank lines are skipped. Fewer than two names
is an error, because a meeting has two duties and one person cannot hold
both.

**The availability grid** (`-s`, default `availability.csv`): a CSV with
one row per meeting, in the order midweek then weekend, week by week, and
one `0`/`1` column per person, `1` meaning unavailable. It is optional: a
missing file means everyone is available and says so once.

Its first row is a header when it does not begin with a digit. The header
names the people the columns belong to, in any order. A header name that
is not in the names file is reported and its column ignored; a person in
the names file with no column is reported and treated as always available.
Without a header, columns are taken in names-file order, as the old
program did, with a warning that says so. If the header's first cell is
`Meeting`, the first column of every row is a label for people and is
skipped. Rows beyond the number of meetings are ignored; meetings beyond
the number of rows are fully available.

**The start date** (`-d YYYYMMDD`): the date of the first midweek meeting.
When absent, the first midweek meeting day on or after the first of next
month. A start date that is not a midweek meeting day is an error that
names the weekday it is and the one it should be, so a typo cannot shift
the whole schedule by a day. Meeting days are two named constants at the
top of the program, Wednesday and Sunday, with a comment saying to change
them there.

**The number of weeks** (`-w`, default 8).

`-g` writes an empty grid to the `-s` path and exits: a header row of
`Meeting` then the names in file order, then one row per meeting whose
first cell is the meeting's label (`Wed 29 Jul 2026 midweek`) and whose
other cells are `0`. It refuses to overwrite a file that already exists,
because the grid is where a person's hand-typed availability lives.

`-o` (default `schedule.csv`) is the output CSV. `-h` prints the help,
which lists every flag and shows a four-line example grid.

## The assignment rule

Meetings are numbered from 1 in date order. Each meeting has two slots,
door then auditorium. For each slot the program picks, from the people who
are available for that meeting and not already holding the other slot in
it:

1. the person with the fewest duties so far;
2. among those, the one whose last duty was longest ago, a person who has
   never had one counting as longest;
3. among those, the one earliest in the names file.

That is fully deterministic: the same inputs give the same schedule every
run. If nobody qualifies the slot is left `UNFILLED`, the schedule still
completes, and the summary lists every unfilled slot with its date and
role and the reason (nobody available).

## Outputs

**The terminal** shows a header with the pool size, weeks and start date;
then each week with its two meetings, each on one line:

```
Week 1
  Wed 29 Jul 2026  midweek   door: Alice              auditorium: Bob
  Sun  2 Aug 2026  weekend   door: Charlie            auditorium: David
```

then a summary: every person with their duty count, sorted by count then
name file order; any grid warnings; any unfilled slots; and the CSV path.

**The CSV** keeps the old columns exactly, so the owner's spreadsheet
workflow is untouched: `Week,Date,Meeting,Door,Auditorium`, dates as
`29 Jul 2026`, meeting as `Midweek Meeting` or `Weekend Meeting`.

## Shape of the program

One entry file and four included ones, each a few dozen lines with one
job, joined with `see "./..."`. A reader who wants to know how a duty is
chosen opens the file named for it and finds nothing else there.

| File | Job | Knows about |
|---|---|---|
| `src/scheduler.vox` | flags, help, the order of the steps, exit codes | everything below, by name only |
| `src/roster.vox` | read the names file into a list of names | textkit |
| `src/calendar.vox` | the meeting days; the start date rule; the moment and label of meeting N | date |
| `src/availability.vox` | read the grid; answer "is this person free at meeting N"; the warnings; write an empty grid | textkit, date (for labels), the roster |
| `src/duties.vox` | the assignment rule; the per-person counts and last-duty record | the roster and availability |
| `src/report.vox` | the terminal schedule, the summary, the CSV | date, the duties |

Constraints the author must design within:

- A `thing` cannot hold a text or a list, and a list cannot hold things, so
  the per-person state is parallel lists indexed by roster position
  (`'duty counts'`, `'last duty meeting'`), and a meeting is described by
  its number, from which its week, kind and moment are computed.
- A library cannot raise the error flag to its caller, so a parse that can
  fail is asked twice: `'reads as a moment'` then `'the moment read from'`.
- Blank lines close every open construct. No blank line inside a loop or
  `if` body, ever.

## Build and test

`Makefile` at the repo root:

- `make` builds `scheduler` from `src/scheduler.vox` with
  `--lib-path $(VOXLIBS)/build`, `VOXLIBS ?= ../english/vox-libs`, so the
  program compiles against a checked-out vox-libs before the libraries
  are installed and against `/usr/include/vox` afterwards without change.
- `make test` runs `tests/run.sh`.

`tests/` holds fixtures and expected outputs, and `run.sh` builds once and
diffs each case, exiting non-zero on any difference. Cases, each a names
file, an optional grid, a command line, and the expected stdout and CSV:

1. five people, four weeks, no grid: every duty filled, counts differ by
   at most one, output byte-identical to the recorded expectation
2. the same with a grid that blocks one person from every midweek
   meeting: that person holds only weekend duties and still has a fair
   count
3. a grid whose header is in a different order from the names file: the
   right people are blocked (this is the bug the rewrite exists to fix)
4. a grid with an unknown header name and a person missing from the
   header: both warnings appear, the run completes
5. a grid with no header: the positional warning appears, columns are
   taken in file order
6. two people, one week: door and auditorium are never the same person in
   one meeting
7. two people, one week, one blocked from everything: `UNFILLED` slots are
   reported with date, role and reason
8. `-g` into a fresh path writes the labelled empty grid; `-g` onto an
   existing path refuses
9. `-d` on a non-meeting weekday is refused with the message naming both
   weekdays
10. one name, or a missing names file: the error message and exit code 1

Expected outputs are recorded from the built program once the author has
checked them by hand against the rule above, and the check is written in
the test's comment.

## Documentation

`README.md` rewritten for the new behaviour: the two files, the rule, the
flags, the grid format with the labelled header, and the build against
vox-libs. It says plainly which libraries it needs and their versions.

## Out of scope

Holiday schedules, notifications, a web interface, role rotation (door one
week, auditorium the next), and any change to the sibling `~/scr/scheduler`
directory, which stays as the owner's working copy until this one replaces
it.
