# Check: 05-no-header

The grid's first line is a data row (`0,0,0,0,0`, starting with a
digit), not a header. Per the rule, the program falls back to the old
program's positional mapping - column *k* is person *k* in
`names.txt` order - and must say so, since silently guessing is
exactly the kind of thing that produced the original bug.

Expected warning, exactly one line:

    the grid has no header row, columns taken in names-file order

Every cell here is `0`, so no one is actually blocked and the
assignment runs exactly as `01-five-people-four-weeks`'s first week
(M1 door Alice/auditorium Bob, M2 door Charlie/auditorium David). The
run completes with status 0 and the one warning line appears after the
summary counts.

Expected output and CSV recorded from the built program after this
check.
