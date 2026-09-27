# Check: 00-help

`-h` prints the help text and exits before touching the names file or
doing any scheduling, so `names.txt` in this case is a placeholder (two
names, unused) and the command line is just `-h`.

Hand check against the plan's "The help text" block (the plan's spec is
byte-exact, so this is a direct transcription, not a computation),
plus the `-v, --version` line added by the `--version` flag, which
post-dates the plan:

- Line 1 names the program and its two duties.
- The usage line and all eight flag lines match the flags declared in
  `src/scheduler.vox`, in the same order, with the same defaults;
  `-v, --version` follows `-h, --help`, matching the order the flags
  are declared in the source.
- The three continuation lines under `-d` are indented to the column
  where "Date of the first" starts (25 spaces), matching the plan's
  `cat -A` byte layout.
- The grid-format paragraph and its three-line example (three people,
  one week, all-zero grid) match the plan's example exactly, including
  the escaped `"Meeting"` quotes.
- Exit code is 0: help is not an error.

Expected output and status recorded from the built program after this
check.
