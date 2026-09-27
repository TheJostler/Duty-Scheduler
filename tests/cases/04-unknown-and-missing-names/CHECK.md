# Check: 04-unknown-and-missing-names

The grid's header names `Alice, Bob, Charlie, David, Zed`: four real
people and one, `Zed`, who is not in `names.txt`. `Eve`, who *is* in
`names.txt`, has no column at all. Nobody is actually marked
unavailable (every cell is `0`), so this case is purely about the two
warnings, not the assignment rule.

Expected warnings, in the order the interface describes (header names
not in the roster, then roster names not in the header):

    Zed is in the grid but not in the names file, column ignored
    Eve has no column in the grid, treated as always available

Zed's column is read and then discarded (it maps to no real person, so
nothing in `'unavailable at'` is ever queried under that name). Eve
gets no row in `'unavailable at'` at all, so `'is free for meeting'`
takes its "no row" branch and treats her as always available - the
same behaviour a fully-missing grid gives everyone, just for one
person instead of all five.

With every real cell `0`, the two meetings assign exactly as in
`01-five-people-four-weeks`'s first week: M1 door Alice/auditorium Bob,
M2 door Charlie/auditorium David. The run completes with status 0;
both warning lines appear, one per line, indented two spaces, after
the summary counts.

Expected output and CSV recorded from the built program after this
check.
