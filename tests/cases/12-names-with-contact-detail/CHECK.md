# Check: 12-names-with-contact-detail

`names.txt` holds the owner's real-file shape: each line is a name, a
colon, a tab, and a fictional phone number (`Alice:\t447900000001`,
...). The new rule in `src/roster.vox` is that a person's name is the
text before the first `:`, trimmed - everything after it, including
the phone number, is ignored. Since `-g` writes its header from
`names`, the header proves the rule: it must read
`Meeting,Alice,Bob,Charlie,David,Eve`, never leaking a colon or a
digit of any phone number.

`-g -w 1 -d 2026-07-29 -s availability.csv` with no grid present at
that path: the path is free, so the program writes a fresh grid and
exits without scheduling.

Expected `availability.csv` is the header above followed by one
labelled zero row per meeting (1 week = 2 meetings, midweek then
weekend), matching the non-padded date form `'the label of meeting'`
uses (`Sun 2 Aug 2026`, one space, not the terminal's two-space `%e`
form - see case `08-gen-fresh`'s `CHECK.md`):

    Meeting,Alice,Bob,Charlie,David,Eve
    Wed 29 Jul 2026 midweek,0,0,0,0,0
    Sun 2 Aug 2026 weekend,0,0,0,0,0

Expected stdout is the single line `Wrote an empty grid for 2 meetings
and 5 people to availability.csv`, and status 0.

Expected output, status, and grid recorded from the built program
after this check.
