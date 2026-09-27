# Check: 10c-crlf-names

`names.txt` here has Windows line endings (`\r\n`) throughout and a
trailing space on the `Charlie` line, the two things a names file
edited in a spreadsheet or Notepad tends to pick up. Review Focus item
1 in the plan calls this out: names read from this file must still
match cleanly (here, against nothing but themselves, but the same
`trim` path is what later has to match a grid header written the same
way).

`src/roster.vox` reads the whole file, splits it into lines with
`'split lines'` (which drops the `\r` immediately before each `\n`,
so a Windows line ending reads the same as a plain one), then `trim`s
each line, which removes the leftover space on `Charlie` too. Five
non-blank lines survive, all clean: `Alice`, `Bob`, `Charlie`, `David`,
`Eve`.

Expected: the header's "People" line reads `People: 5` - not 4, not 5
names each carrying stray whitespace - and the run completes (status
0), since 29 July 2026 is a Wednesday.

**Updated for Task 3:** `scheduler.vox` now runs the whole pipeline in
one pass, so `expected.out` records the full run, not just the header.
The names read from this CRLF file are the same five, in the same
order, as `01-five-people-four-weeks`, so the one week scheduled here
(meetings 1-2) matches that case's hand-checked trace exactly: M1 door
Alice/auditorium Bob, M2 door Charlie/auditorium David. This case is
still read for what it tests: that the CRLF/trim path produces a clean
five-person roster in the first place.

Expected output and status recorded from the built program after this
check.
