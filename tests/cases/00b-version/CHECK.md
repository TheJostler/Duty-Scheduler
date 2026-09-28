# Check: 00b-version

`-v` prints the version line and exits before touching the names file
or doing any scheduling, so `names.txt` here is a placeholder (two
names, unused), same as `00-help`.

`'show version'` prints `"{Program} (duty-scheduler) {Program Version}
by Josjuar Lister"`, where `Program` is `arguments's name` - argv[0] as
the shell actually typed it - and `'Program Version'` is the constant
`"1.1.0"` (bumped from `"1.0.0"` for "the run starts at the first
meeting of either kind"). The harness now copies the built binary into
each case's work directory and runs it as `./scheduler`, so argv[0] is
`./scheduler` on every machine, making the line byte-stable to record:

    ./scheduler (duty-scheduler) 1.1.0 by Josjuar Lister

Exit code is 0: showing the version is not an error.

Expected output and status recorded from the built program after this
check.
