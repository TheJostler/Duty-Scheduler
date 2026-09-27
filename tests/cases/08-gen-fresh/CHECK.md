# Check: 08-gen-fresh

`-g` with no `availability.csv` in the case directory: the path is
free, so the program should write a fresh grid and exit, without
reading the roster for scheduling or doing any assignment at all.

Expected `availability.csv` is exactly the plan's own worked example
(three people, one week starting 29 Jul 2026), with every cell `0`
instead of the example's `0,1,0`:

    Meeting,Alice,Bob,Charlie
    Wed 29 Jul 2026 midweek,0,0,0
    Sun 2 Aug 2026 weekend,0,0,0

Note the date on the second row is `Sun 2 Aug 2026` (one space before
`2`), not `Sun  2 Aug 2026` (two spaces, the terminal's `%e`-padded
form) - the grid label uses `'the label of meeting'`, which the plan's
own byte-exact example fixes as the non-padded form (`%-d`), distinct
from the terminal week-lines. This is Task 4's correction to
`'the label of meeting'` (see `NOTES.md`).

Expected stdout is the single line `Wrote an empty grid for 2 meetings
and 3 people to availability.csv`, and status 0.

Expected output, status, and grid recorded from the built program
after this check.
