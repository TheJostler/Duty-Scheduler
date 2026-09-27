# Check: 03-header-in-different-order

This is the bug the rewrite exists to fix. `names.txt` lists people in
the order Alice, Bob, Charlie, David, Eve. The grid's header lists
them in the *exact reverse* order (`Eve,David,Charlie,Bob,Alice`) and
blocks the header's first-listed column - Eve - at meeting 1.

The old program matched columns to people by **position**, not name:
with the header reversed, a positional match would read column 1
("blocked") against names-file position 1 (Alice), incorrectly
blocking Alice instead of Eve. The rewrite matches by the header's
name text, so it must block the person actually named in that column,
regardless of where her column sits.

- **M1** (midweek, Eve blocked): eligible {Alice,Bob,Charlie,David},
  all tied at 0 duties/0 last-duty → door **Alice** (lowest position),
  auditorium **Bob** (next-lowest, Alice now excluded as
  already-on-duty). Eve does not appear anywhere in M1.
- **M2** (weekend, everyone free including Eve): fewest-duty tie
  Charlie/David/Eve → door **Charlie**, auditorium **David**.

Expected: Alice is present at M1 (proving she was *not* wrongly
blocked), Eve is absent from M1, and the run completes normally
(status 0).

Expected output and CSV recorded from the built program after this
check.
