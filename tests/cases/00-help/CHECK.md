# Check: 00-help

`-h` prints the help text and exits before touching the names file or
doing any scheduling, so `names.txt` in this case is a placeholder (two
names, unused) and the command line is just `-h`.

Hand check against the plan's "The help text" block (the plan's spec is
byte-exact, so this is a direct transcription, not a computation),
plus the `-v, --version` line added by the `--version` flag, which
post-dates the plan, and the `-d` wording updated for "the run starts
at the first meeting of either kind":

- Line 1 names the program and its two duties.
- The usage line and all eight flag lines match the flags declared in
  `src/scheduler.vox`, in the same order, with the same defaults;
  `-v, --version` follows `-h, --help`, matching the order the flags
  are declared in the source.
- The `-d` text now reads "Date of the first meeting, midweek or
  weekend (default: the first meeting on or after the 1st of next
  month)", since `-d` names either kind's day, not only Wednesday. The
  three continuation lines are still indented to the column where
  "Date of the first" starts (25 spaces), the same greedy fill at
  width 80 as before, just re-wrapped for the new wording.
- The grid-format paragraph and its three-line example (three people,
  one week, all-zero grid) match the plan's example exactly, including
  the escaped `"Meeting"` quotes.
- Exit code is 0: help is not an error.

Expected output and status recorded from the built program after this
check.
