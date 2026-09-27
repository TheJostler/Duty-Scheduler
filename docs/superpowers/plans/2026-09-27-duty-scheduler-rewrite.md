# Duty Scheduler Rewrite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `src/scheduler.vox` with a readable Vox 0.4.15 program that assigns door and auditorium duties fairly across a run of midweek and weekend meetings, honouring an availability grid matched by name.

**Architecture:** One entry file and five included files, each owning one job and the global state for it. Dates come from the `date` library (a moment is seconds since the epoch), text splitting from `textkit` 0.2. Per-person state is parallel lists indexed by roster position; per-meeting state is parallel lists indexed by meeting number. A shell test harness builds once and diffs recorded outputs.

**Tech Stack:** Vox 0.4.15 (`vox`), vox-libs 0.3.0 (`date` 0.1, `textkit` 0.2, installed in `/usr/include/vox` and `/usr/lib64`), GNU make, bash, diff.

**Spec:** `docs/superpowers/specs/2026-09-27-duty-scheduler-rewrite-design.md`. Library design: `~/scr/english/vox-libs/docs/plans/315_date_and_textkit_0_2.md`.

## Global Constraints

- Every line of Vox must pass the style guide's read-aloud test (`~/scr/vox/docs/STYLE.md`): names are the thing's true name, no `i`/`n`/`buf`, booleans read as conditions, comments say why. The reference programs are `cat.vox`, `pi.vox`, `controller.vox` in `~/scr/vox/examples/`.
- No blank line inside a loop or `if` body, ever: a blank line closes every open construct (LANGUAGE.md, "The termination rule"). Blank lines only between top-level constructs.
- Libraries are consumed by bare name: `see date version "0.1" from "date.lib".` and `see textkit version "0.2" from "textkit.lib".` A file may repeat a library `see` the entry file already made (verified: the compiler tolerates it), so each file states the libraries it uses.
- Included files are joined with `see "./<file>.vox".` from `src/scheduler.vox`, in dependency order.
- A text literal inside a format hole is a parse error in vox 0.4.15 (`"{f of "x"}"`): hoist the literal into a named variable first.
- Reserved words met in this domain that cannot be bare variable or parameter names: `when`, `second`, `seconds`, `day`, `days`, `hour`, `hours`, `minute`, `minutes`, `month`, `months`, `year`, `years`, `unix`, `current`, `free`, `flag`, `empty`, `name` (contextual; avoid). Quoted multi-word names may contain them.
- A library cannot raise the error flag to its caller: ask `'reads as a moment'` before `'the moment read from'`.
- Meeting days are the two named constants in `src/calendar.vox` (Wednesday 3, Sunday 7).
- The CSV columns and value formats are unchanged from the old program: `Week,Date,Meeting,Door,Auditorium`, dates as `29 Jul 2026`, meeting as `Midweek Meeting` / `Weekend Meeting`.
- Exit codes: 0 on success (including a schedule with unfilled slots), 1 for any input or usage error.
- Do not touch `~/scr/scheduler` (the owner's working copy) or anything in vox-libs.
- Test fixtures use fictional names only.

## Review Focus

1. A names file with Windows line endings or trailing spaces: names must still match the grid header, because both go through `trim` and `'split lines'` drops the `\r`. Pinned in Task 2.
2. A grid row shorter than the number of people, or longer: short rows leave the missing people available; extra cells are ignored. Pinned in Task 4.
3. A `-d` value that reads as a moment but on the wrong weekday, and one that reads as a relative description (`next wednesday`): the first is refused naming both weekdays, the second is accepted. Pinned in Task 2.
4. Two people and one blocked at every meeting: every slot for the other is filled, every second slot is `UNFILLED`, and the run exits 0. Pinned in Task 4.
5. `-g` when the output path already exists: refused with exit 1 and the file untouched. Pinned in Task 4.

---

## Verified idioms

These compiled and ran on this machine on 2026-09-27 against the installed libraries. Use them as written.

```vox
see date version "0.1" from "date.lib".
see textkit version "0.2" from "textkit.lib".

(A map from a name to a list of booleans, read back and indexed)
a map called 'unavailable at' is {}.
a list called 'row for alice' is [false, true, false].
Set 'unavailable at''s "Alice" to 'row for alice'.
a text called person is "Alice".
a list called row is 'unavailable at''s "{person}".
a boolean called blocked is element 2 of row.
Print "alice blocked at meeting 2: {blocked}, row length {row's length}".
a list called 'missing row' is 'unavailable at''s "Nobody".
On error Print "no row for Nobody, length {'missing row''s length}".

(Does a path exist)
a text called path is "/etc/hostname".
If path is available then, Print "exists".

(Splitting a CSV row, and telling a header from a data row)
a list called cells is 'split on' of "Meeting,Alice,Bob" and ",".
a text called 'first cell' is element 1 of cells.
If 'first cell' is "Meeting" then, Print "labelled".
a buffer called line is "0,1,0".
a number called 'first byte' is byte 1 of line.
If 'first byte' is greater than or equal to 48 and 'first byte' is less than or equal to 57 then, Print "starts with a digit".

(Parallel lists and padding)
a list called counts is [].
For each position from 1 to 3, append 0 to counts.
Set element 2 of counts to 5.
a text called padded is 'pad right' of "Bob" and 8.

(Dates)
a number called start is 'the moment read from' of "2026-07-29".
a text called layout is "%a %e %b %Y".
Print 'the moment written as' of start and layout.          (Wed 29 Jul 2026)
a text called 'csv layout' is "%-d %b %Y".
a number called sunday is 'days later' of start and 4.
Print 'the moment written as' of sunday and 'csv layout'.   (2 Aug 2026)
Print "weekday {'the weekday of' of start}".                 (3)
a number called 'relative start' is 'the moment described by' of "next wednesday" and start.
a text called compact is "20260729".
Print "reads compact: {'reads as a moment' of compact}".     (1)
```

## The output, exactly

Terminal, for five people, two weeks, no grid, start 29 Jul 2026 (names padded to the longest name plus two):

```
Duty schedule
=============
People: 5
Weeks: 2
First midweek meeting: Wed 29 Jul 2026
Availability: no grid at availability.csv, everyone is available

Week 1
  Wed 29 Jul 2026  midweek   door: Alice      auditorium: Bob
  Sun  2 Aug 2026  weekend   door: Charlie    auditorium: David

Week 2
  Wed  5 Aug 2026  midweek   door: Eve        auditorium: Alice
  Sun  9 Aug 2026  weekend   door: Bob        auditorium: Charlie

Summary
-------
  2  Alice
  2  Bob
  2  Charlie
  1  David
  1  Eve
CSV written to schedule.csv
```

When a grid was read the availability line is `Availability: read from availability.csv`. When there are warnings, a `Warnings` block follows the summary counts, one line each, indented two spaces; when there are unfilled slots, an `Unfilled slots` block follows, one line each: `  Wed 29 Jul 2026 midweek door: nobody is available`. The summary lists people by duty count, most first, ties in names-file order. An unfilled slot prints `UNFILLED` in place of the name in the week lines and in the CSV.

The CSV for the same run:

```
Week,Date,Meeting,Door,Auditorium
1,29 Jul 2026,Midweek Meeting,Alice,Bob
1,2 Aug 2026,Weekend Meeting,Charlie,David
2,5 Aug 2026,Midweek Meeting,Eve,Alice
2,9 Aug 2026,Weekend Meeting,Bob,Charlie
```

The help text:

```
duty-scheduler: fair door and auditorium duties for midweek and weekend meetings

Usage: scheduler [OPTIONS]
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

Grid format: a header row of "Meeting" then the names, then one row per meeting
(midweek, weekend, midweek, ...) whose first cell is the meeting's label and
whose other cells are 0 (available) or 1 (unavailable). Columns are matched
to people by the header name, in any order. Example for three people, one week:
  Meeting,Alice,Bob,Charlie
  Wed 29 Jul 2026 midweek,0,1,0
  Sun 2 Aug 2026 weekend,0,0,0
```

The empty grid `-g` writes, for three people and one week starting 29 Jul 2026, is exactly the example in the help text with every cell `0`.

## The test harness

`tests/run.sh` builds `scheduler` once via `make`, then for each directory under `tests/cases/` copies it to a temp directory, runs the binary there with the arguments in `args` (one line, `xargs`-split), captures stdout and stderr together into `actual.out` and the exit status into `actual.status`, and diffs `expected.out`, `expected.status`, and, when present, `expected.csv` against `schedule.csv` (or `expected.grid` against `availability.csv` for the `-g` cases). It prints `PASS <case>` or `FAIL <case>` with the diff, and exits 1 if any case failed. Every case passes an explicit `-d`, because the default start depends on today's date.

Each case directory holds a `CHECK.md` with the hand check: for a schedule case, the reasoning that the recorded assignments follow the rule (fewest duties, then longest since last duty, then file order); for an error case, the message expected and why. Expected files are recorded from the built program only after that check is written.

---

### Task 1: Skeleton, flags, help, harness

**Files:**
- Create: `Makefile`, `src/scheduler.vox`, `tests/run.sh`, `tests/cases/00-help/{args,names.txt,expected.out,expected.status,CHECK.md}`
- Delete: the old `src/scheduler.vox` content is replaced wholesale (git keeps the history).

**Interfaces:**
- Produces: the flags `weeks` (number, default 8), `'names path'` (text, default `names.txt`), `'start date as typed'` (text, default empty), `'grid path'` (text, default `availability.csv`), `'wants an empty grid'` (boolean), `'csv path'` (text, default `schedule.csv`), `'wants help'` (boolean). Every later file reads these globals by name.

- [ ] **Step 1: Write the Makefile**

```make
VOX     ?= vox
VOXLIBS ?= ../english/vox-libs

scheduler: src/*.vox
	$(VOX) src/scheduler.vox --lib-path $(VOXLIBS)/build -o scheduler

.PHONY: test clean
test: scheduler
	tests/run.sh

clean:
	rm -f scheduler
```

- [ ] **Step 2: Write tests/run.sh** as described under "The test harness", executable, `set -u`, using `mktemp -d` per case and `diff -u`.

- [ ] **Step 3: Write src/scheduler.vox** with the seven flags, the help text above printed when `'wants help'`, `Exit 0` after it, and a check that `weeks` is at least 1 (`scheduler: --weeks must be at least 1`, exit 1). Nothing else yet.

- [ ] **Step 4: Record case 00-help**: `args` is `-h`, `expected.out` is the help text, `expected.status` is `0`.

- [ ] **Step 5: Run `make test`**, expect `PASS 00-help`.

- [ ] **Step 6: Commit** `feat: skeleton, flags, help and the test harness`.

### Task 2: The roster and the calendar

**Files:**
- Create: `src/roster.vox`, `src/calendar.vox`
- Modify: `src/scheduler.vox` (see the two files, read the names, resolve the start date)
- Create: `tests/cases/09-start-date-wrong-weekday/`, `tests/cases/09b-start-date-relative/`, `tests/cases/10-one-name/`, `tests/cases/10b-missing-names-file/`, `tests/cases/10c-crlf-names/`

**Interfaces:**
- Produces, in `src/roster.vox`:
  - `a list called names is [].` (global, roster order)
  - `To 'read the names from' with a text called path.` fills `names`; on a file that cannot be opened prints `scheduler: cannot open <path>` and exits 1; skips blank lines; each name is the trimmed line; fewer than two names prints `scheduler: need at least two people in <path>` and exits 1.
  - `To 'the longest name length'. Return a number.`
- Produces, in `src/calendar.vox`:
  - `a number called 'the midweek meeting day' is 3.` and `a number called 'the weekend meeting day' is 7.` with the comment saying to change them here.
  - `a number called 'meeting count' is 0.` and `a number called 'the first midweek moment' is 0.` (globals set by the entry file)
  - `To 'the week of meeting' with a number called 'meeting number'. Return a number.` ((n add 1) divide 2)
  - `To 'meeting is at the weekend' with a number called 'meeting number'. Return a boolean.` (even numbers)
  - `To 'the kind of meeting' with a number called 'meeting number'. Return a text.` (`midweek` or `weekend`)
  - `To 'the moment of meeting' with a number called 'meeting number'. Return a number.` (first midweek moment, plus week minus one weeks, plus the weekend day minus the midweek day in days when at the weekend)
  - `To 'the long date of' with a number called moment. Return a text.` (`%a %e %b %Y`)
  - `To 'the short date of' with a number called moment. Return a text.` (`%-d %b %Y`)
  - `To 'the label of meeting' with a number called 'meeting number'. Return a text.` (`Wed 29 Jul 2026 midweek`, built from the long date and the kind)
  - `To 'the default first midweek moment'. Return a number.` (the midweek day on or after the start of the month after now)
  - `To 'the first midweek moment typed as' with a text called 'the start date as typed'. Return a number.` Empty text gives the default. Otherwise: if it `'reads as a moment'` use it; else if it `'reads as a description'` use `'the moment described by'` relative to now; else print `scheduler: cannot read the start date "<typed>"` and exit 1. Take the start of that day. If its weekday is not the midweek day, print `scheduler: <long date> is a <weekday name>, but the first midweek meeting must be a <midweek weekday name>` and exit 1.

- [ ] **Step 1: Write src/roster.vox** and **src/calendar.vox** to the interfaces above.
- [ ] **Step 2: Wire scheduler.vox**: after the help and weeks check, `'read the names from' with 'names path'`, set `'meeting count'` to `weeks multiply 2`, set `'the first midweek moment'` from the typed flag. Print the header's first five lines (see "The output, exactly") so the cases have output to check.
- [ ] **Step 3: Record cases**: 09 (`-d 2026-07-30 -w 1`, five names: the refusal naming Thursday and Wednesday, status 1); 09b (`-d "next wednesday"` cannot be recorded stably, so instead `-d "2026-07-22 + 1 week"` which the description parser reads: header shows `Wed 29 Jul 2026`, status 0); 10 (one name: the message, status 1); 10b (`-f nowhere.txt`: cannot open, status 1); 10c (names file with `\r\n` endings and a trailing space on one line: header shows `People: 5`, status 0).
- [ ] **Step 4: `make test`**, all cases pass.
- [ ] **Step 5: Commit** `feat: read the roster and resolve the meeting calendar`.

### Task 3: Duties and the report

**Files:**
- Create: `src/duties.vox`, `src/report.vox`
- Modify: `src/scheduler.vox`
- Create: `tests/cases/01-five-people-four-weeks/`, `tests/cases/06-two-people-one-week/`

**Interfaces:**
- Produces, in `src/duties.vox` (all lists indexed from 1):
  - `a list called 'duty counts' is [].` (per person)
  - `a list called 'last duty meeting' is [].` (per person, 0 = never)
  - `a list called 'door holders' is [].` and `a list called 'auditorium holders' is [].` (per meeting, roster position, 0 = unfilled)
  - `a list called 'unfilled slots' is [].` (texts, `<label> <role>: nobody is available`)
  - `To 'prepare the duties'.` sizes the lists from `names` and `'meeting count'`.
  - `To 'the best person for' with a number called 'meeting number' and a number called 'the person already on duty'. Return a number.` The rule from the spec: among positions that are free for the meeting (Task 4 supplies `'is free for meeting'`; until then a stub in `src/availability.vox` returning true is acceptable but Task 4 replaces it) and not equal to `'the person already on duty'`: fewest duties; then smallest `'last duty meeting'` (0 wins); then lowest position. Returns 0 when nobody qualifies.
  - `To 'assign the duties of meeting' with a number called 'meeting number'.` picks door then auditorium, records holders, increments the count and sets the last duty meeting for each, appends to `'unfilled slots'` for a 0.
  - `To 'assign every duty'.` loops 1..`'meeting count'`.
- Produces, in `src/report.vox`:
  - `To 'the holder text for' with a number called position. Return a text.` (the name, or `UNFILLED`)
  - `To 'print the schedule'.` the week blocks, exactly as shown.
  - `To 'print the summary'.` the summary, warnings and unfilled blocks, and the CSV line.
  - `To 'write the csv to' with a text called path.` prints `scheduler: cannot write <path>` and exits 1 on failure.

- [ ] **Step 1: Write src/availability.vox as a stub** holding `a list called warnings is [].`, `a text called 'the availability note' is "no grid at availability.csv, everyone is available".` and `To 'is free for meeting' with a text called person and a number called 'meeting number'. Return a boolean, true.` (Task 4 replaces this file.)
- [ ] **Step 2: Write src/duties.vox and src/report.vox** to the interfaces.
- [ ] **Step 3: Wire scheduler.vox**: prepare, assign every duty, print the header (with the availability note), the schedule, the summary, write the CSV.
- [ ] **Step 4: Record cases** 01 (five names, `-w 4 -d 2026-07-29`; `CHECK.md` walks the first eight slots by the rule and notes that counts differ by at most one) and 06 (two names, `-w 1 -d 2026-07-29`; door and auditorium differ in both meetings).
- [ ] **Step 5: `make test`**, all cases pass.
- [ ] **Step 6: Commit** `feat: fair duty assignment and the schedule report`.

### Task 4: The availability grid

**Files:**
- Replace: `src/availability.vox`
- Modify: `src/scheduler.vox` (`-g` branch before any scheduling; load the grid after the calendar is set)
- Create: `tests/cases/02-one-person-blocked-midweek/`, `03-header-in-different-order/`, `04-unknown-and-missing-names/`, `05-no-header/`, `07-unfillable/`, `08-gen-fresh/`, `08b-gen-refuses/`, `11-short-and-long-rows/`

**Interfaces:**
- Produces, in `src/availability.vox`:
  - `a map called 'unavailable at' is {}.` name to a list of booleans indexed by meeting number, always `'meeting count'` long.
  - `a list called warnings is [].`
  - `a text called 'the availability note' is "".`
  - `To 'load the grid from' with a text called path.` If `path is not available`: note `no grid at <path>, everyone is available`, return. Otherwise note `read from <path>`, then: read every line with `Read line`, trim, skip blanks. If the first line's first byte is not a digit it is the header: split on `,`, trim each cell; if the first cell is `Meeting` (case as written) the rows are labelled and cell 1 of every row is skipped. Each header name not in `names` adds the warning `<name> is in the grid but not in the names file, column ignored`; each name in `names` not in the header adds `<name> has no column in the grid, treated as always available`. Without a header, add the warning `the grid has no header row, columns taken in names-file order` and map column k to name k. Data rows are meetings 1, 2, 3 ... in order; a cell of `1` marks that person unavailable at that meeting; rows past `'meeting count'` are ignored; cells past the header's columns are ignored; a short row leaves the rest available.
  - `To 'is free for meeting' with a text called person and a number called 'meeting number'. Return a boolean.` true when the person has no row or the row's element is false.
  - `To 'write an empty grid to' with a text called path.` If `path is available` print `scheduler: <path> already exists, not overwriting it` and exit 1. Otherwise write the header and one labelled row of zeros per meeting, print `Wrote an empty grid for <count> meetings and <people> people to <path>`, exit 0.

- [ ] **Step 1: Replace the stub** with the real `src/availability.vox`.
- [ ] **Step 2: Wire scheduler.vox**: after the calendar is set, if `'wants an empty grid'` then write the grid and exit; otherwise load the grid before preparing duties.
- [ ] **Step 3: Record cases**: 02 (five names, `-w 4`, a labelled grid blocking Bob at every midweek meeting; check that Bob holds only weekend duties and his count is within one of the others); 03 (header lists the names in reverse order, blocks the first-listed name at meeting 1; check that person is absent from meeting 1); 04 (header has `Zed` and lacks `Eve`: both warnings appear, run completes, status 0); 05 (no header row: the positional warning appears, status 0); 07 (two names, `-w 1`, Bob blocked at both meetings: two `UNFILLED` slots, listed with labels, status 0, CSV holds `UNFILLED`); 08 (three names, `-g -w 1 -d 2026-07-29 -s availability.csv` into a case dir without a grid: `expected.grid` is the help-text example with zeros, status 0); 08b (same with a grid present: refusal, status 1, and the harness also diffs the grid to prove it is untouched); 11 (a row of two cells for five people and a row of eight cells: the run completes, the short row's missing people are available).
- [ ] **Step 4: `make test`**, all cases pass.
- [ ] **Step 5: Commit** `feat: availability grid matched by header name`.

### Task 5: README and a style pass

**Files:**
- Rewrite: `README.md`
- Modify: any `src/*.vox` the style pass touches

- [ ] **Step 1: Rewrite README.md** for the new behaviour: what the program is for, the two input files with the labelled grid format, the assignment rule in three lines, every flag, `make` and `make test`, and the dependency on vox-libs 0.3.0 (`date` 0.1, `textkit` 0.2) with the `VOXLIBS` override for a checkout.
- [ ] **Step 2: Read every src file aloud** against `~/scr/vox/docs/STYLE.md`; rename anything that is not the thing's true name; delete any comment that restates its line.
- [ ] **Step 3: `make test`**, all cases pass.
- [ ] **Step 4: Commit** `docs: README for the rewrite; style pass`.
