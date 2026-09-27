# Check: 05-no-header

The grid's first line is a data row (`1,0,0,0,0`, starting with a
digit), not a header. Per the rule, the program falls back to the old
program's positional mapping - column *k* is person *k* in
`names.txt` order (Alice=1, Bob=2, Charlie=3, David=4, Eve=5) - and
must say so.

Expected warning, exactly one line:

    the grid has no header row, columns taken in names-file order

The grid blocks column 1 (Alice) at meeting 1 and column 2 (Bob) at
meeting 2, so this case pins the positional fallback actually doing
something, not just being announced:

- **M1 (midweek, Alice blocked)**: eligible {Bob,Charlie,David,Eve},
  all tied at 0/0 → door **Bob** (lowest position); auditorium, Bob
  now excluded → **Charlie** (next lowest).
- **M2 (weekend, Bob blocked)**: fewest-duty tie Alice/David/Eve (Bob
  excluded, Charlie has 1) → door **Alice** (lowest position);
  auditorium, Alice excluded, tie David/Eve → **David**.

Final counts: Alice 1, Bob 1, Charlie 1, David 1, Eve 0. Neither block
would land on the right person if columns were matched some other way
than straight file order, so this also indirectly confirms the
positional fallback maps 1:1 and doesn't, say, shift by one or reverse.

Expected output and CSV recorded from the built program after this
check.
