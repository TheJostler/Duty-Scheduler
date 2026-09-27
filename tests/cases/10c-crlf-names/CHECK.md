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

Expected output and status recorded from the built program after this
check.
