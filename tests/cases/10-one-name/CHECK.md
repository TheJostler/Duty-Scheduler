# Check: 10-one-name

`names.txt` holds one name. A meeting has two duties (door and
auditorium) and one person cannot hold both in the same meeting, so a
roster of fewer than two people can never produce a schedule; the
program must refuse before it tries.

Expected: `src/roster.vox`'s `'read the names from'` counts one name
after trimming and skipping blanks, which is less than two, so it
prints `scheduler: need at least two people in <path>` naming the path
it was given and exits 1, before any calendar or duty work happens.

Expected output and status recorded from the built program after this
check.
