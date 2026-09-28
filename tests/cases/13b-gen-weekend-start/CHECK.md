# Check: 13b-gen-weekend-start

`-g` with no `availability.csv` in the case directory and `-d
2026-10-04` (a Sunday): the path is free, so the program writes a
fresh grid and exits, without reading the roster for scheduling or
doing any assignment. `-w 1` gives 2 meetings.

`'the first meeting moment typed as'` accepts the Sunday and sets
`'the run starts at the weekend'` to true, so meeting 1 is weekend and
meeting 2 is midweek (the alternation is unchanged - only which kind
comes first has flipped). `'the label of meeting'` uses `'the short
date of'`'s non-padded layout (`%-d`, same correction already checked
in `08-gen-fresh`), so the rows are:

    Meeting,Alice,Bob,Charlie
    Sun 4 Oct 2026 weekend,0,0,0
    Wed 7 Oct 2026 midweek,0,0,0

Sun 4 Oct 2026 is meeting 1 itself (`'the first meeting moment'`,
unchanged). Wed 7 Oct 2026 is meeting 2: the 3-day gap from Sunday to
Wednesday, `((3 subtract 7) add 7) modulo 7`, added to 4 Oct - the
mirror image of `13-weekend-start`'s calendar check, using `-w 1`
instead of `-w 2` so only the first week's pair of rows exists here.

Expected stdout is the single line `Wrote an empty grid for 2 meetings
and 3 people to availability.csv`, and status 0.

Expected output, status, and grid recorded from the built program
after this check.
