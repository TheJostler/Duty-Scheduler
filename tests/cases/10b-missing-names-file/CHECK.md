# Check: 10b-missing-names-file

`-f nowhere.txt` names a path that does not exist in the case
directory (deliberately: this case has no `names.txt` of any kind, so
there is nothing for `nowhere.txt` to collide with).

Expected: `Open a file for reading called ... at path.` fails, `On
error` catches it, and the program prints
`scheduler: cannot open nowhere.txt`, naming the exact path it was
given (not a resolved absolute path, not a generic message), and exits
1 before reading the calendar or doing any scheduling.

Expected output and status recorded from the built program after this
check.
