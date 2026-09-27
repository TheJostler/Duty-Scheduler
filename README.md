# Duty Scheduler

A congregation has two meetings a week, midweek and weekend. Each
needs an attendant on the door and one in the auditorium. This program
hands out those four duties a week across everyone in a names file,
fairly, without giving a duty to someone who has said they are away,
and publishes the result as a schedule you can read and a CSV your
spreadsheet can open.

## The two input files

**The names file** (`-f`, default `names.txt`): one person per line,
the name being the text before the first `:` on the line, trimmed -
a phone number or a note may follow the colon and is ignored. Blank
lines are skipped. Fewer than two names is an error - a meeting has
two duties and one person cannot hold both.

**The availability grid** (`-s`, default `availability.csv`): a CSV
with one row per meeting, in order (midweek, weekend, midweek, ...),
and one `0`/`1` column per person, `1` meaning unavailable. It is
optional: a missing file means everyone is available.

Its first row is a header when it does not begin with a digit. The
header names the people the columns belong to, **in any order** -
columns are matched by the header's name text, not by position. A
header name that is not in the names file is reported and its column
ignored; a person in the names file with no column is reported and
treated as always available. Without a header, columns are taken in
names-file order, with a warning that says so. If the header's first
cell is `Meeting`, that first column of every row is a label for the
row and is skipped when matching data. Rows beyond the number of
meetings are ignored; meetings beyond the number of rows are fully
available; a short row leaves its missing people available, and extra
cells past the header's columns are ignored.

Example, three people, one week:

```
Meeting,Alice,Bob,Charlie
Wed 29 Jul 2026 midweek,0,1,0
Sun 2 Aug 2026 weekend,0,0,0
```

`-g` writes an empty grid like the one above (every cell `0`) to the
`-s` path and exits; it refuses to overwrite a file that already
exists, since the grid is where a person's hand-typed availability
lives.

## The assignment rule

For each meeting's two slots (door, then auditorium), among the
people who are available for that meeting and not already holding the
other slot in it, pick: the person with the fewest duties so far;
then, among those, the one whose last duty was longest ago (never
having had one counts as longest); then, among those, the one earliest
in the names file. If nobody qualifies, the slot is `UNFILLED` and the
schedule still completes.

## Flags

```
  -f, --file <path>      Names file, one person per line (default: names.txt)
  -w, --weeks <N>        Number of weeks to schedule (default: 8)
  -d, --start <date>     Date of the first midweek meeting (default: the first
                         midweek meeting day on or after the 1st of next month).
                         Accepts 2026-07-29, 20260729, 29 Jul 2026, or a phrase
                         such as "next wednesday".
  -s, --schedule <path>  Availability grid CSV (default: availability.csv)
  -g, --gen              Write an empty availability grid to the -s path and exit
  -o, --output <path>    Schedule CSV to write (default: schedule.csv)
  -h, --help             Show this help
  -v, --version          Show the version
```

The meeting days themselves (Wednesday and Sunday) are two named
constants at the top of `src/calendar.vox`; change them there if the
congregation's schedule ever moves.

## Output

The terminal shows a header (pool size, weeks, start date, and where
the availability came from), each week's two meetings on their own
lines, then a summary: every person's duty count (most first, ties in
names-file order), any grid warnings, and any unfilled slots.

The CSV keeps the columns `Week,Date,Meeting,Door,Auditorium`, dates
as `29 Jul 2026`, meeting as `Midweek Meeting` or `Weekend Meeting`, so
an existing spreadsheet workflow built on it is untouched. An unfilled
slot prints `UNFILLED` in both the terminal and the CSV.

## Build and test

Requires [Vox](https://vox-lang.dev) 0.4.15 and vox-libs 0.3.0
(`date` 0.1, `textkit` 0.2), installed at `/usr/include/vox` and
`/usr/lib64`.

```
make          # builds ./scheduler
make test     # runs tests/run.sh against tests/cases/
```

`Makefile` builds against `$(VOXLIBS)/build`, where `VOXLIBS` defaults
to `../english/vox-libs`; override it to point at any checkout of
vox-libs, so the program compiles against a development build before
the libraries are installed system-wide, and against the installed
copy afterwards without any change:

```
make VOXLIBS=/path/to/vox-libs
```

## Layout

One entry file and five included ones, each a few dozen lines with one
job:

| File | Job |
|---|---|
| `src/scheduler.vox` | flags, help, the order of the steps, exit codes |
| `src/roster.vox` | read the names file |
| `src/calendar.vox` | the meeting days; the start date rule; a meeting's moment and label |
| `src/availability.vox` | read the grid; "is this person free at meeting N"; the warnings; write an empty grid |
| `src/duties.vox` | the assignment rule; the per-person counts and last-duty record |
| `src/report.vox` | the terminal schedule, the summary, the CSV |
