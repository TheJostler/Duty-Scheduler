# Check: 11-short-and-long-rows

Five people, five real columns in the header. The midweek row has only
2 cells (`0,1`) - short by three; the weekend row has 8 (`0,0,0,0,0,
1,1,1`) - long by three. Neither should crash or misalign anyone's
column.

- **M1 (midweek), short row `0,1`**: Alice's cell is `0` (free), Bob's
  is `1` (blocked). Charlie, David and Eve have no cell in this row at
  all - the design says a short row "leaves the missing people
  available", so all three stay free. Eligible: {Alice, Charlie,
  David, Eve} (Bob excluded). All tied at 0/0 → door **Alice** (lowest
  position); auditorium, Alice now excluded → **Charlie** (next
  lowest).
- **M2 (weekend), long row `0,0,0,0,0,1,1,1`**: the first five cells
  (one per real column) are all `0` - free - and the extra three
  cells past the header's five columns are ignored entirely. Counts
  entering M2: Alice 1, Charlie 1, Bob/David/Eve 0. Fewest-duty tie
  among Bob/David/Eve → door **Bob** (lowest position); auditorium,
  Bob excluded, tie David/Eve → **David**.

Final counts: Alice 1, Bob 1, Charlie 1, David 1, Eve 0. The run
completes with status 0; no cell past either row's real column count
is ever read, and no cell missing from the short row blocks anyone.

Expected output and CSV recorded from the built program after this
check.
