# Check: 02-one-person-blocked-midweek

Same five names and four weeks as `01-five-people-four-weeks`, but the
grid blocks Bob (`1`) at every midweek meeting and leaves him free
(`0`) at every weekend one. The header names the columns in file order,
so this case is really about `'is free for meeting'` correctly
excluding Bob from the midweek candidate pool, not about the
header-matching Task 4 exists to fix (that is `03`).

Walking the eight slots (Bob excluded from every midweek pool):

- **M1** (midweek): eligible {Alice,Charlie,David,Eve} all tied → door
  **Alice**, auditorium **Charlie** (Bob never considered).
- **M2** (weekend, everyone eligible): fewest-duty tie among
  Bob/David/Eve → door **Bob**, auditorium **David**.
- **M3** (midweek): Eve is the only 0-duty eligible person → door
  **Eve**; auditorium tie between Alice/Charlie (1 duty, same last-duty)
  → **Alice** (lower position).
- **M4** (weekend): fewest-duty tie Bob/David/Eve, last-duty smallest
  Charlie(1) → door **Charlie**; auditorium tie Bob/David(2) → **Bob**
  (lower position).
- **M5** (midweek): fewest-duty tie David/Eve, last-duty smallest
  David(2) → door **David**; auditorium Eve is the only 1-duty
  eligible person → **Eve**. All five now tied at 2 duties.
- **M6** (weekend): last-duty smallest Alice(3) → door **Alice**;
  auditorium tie Bob/Charlie(4) → **Bob** (lower position).
- **M7** (midweek): fewest-duty tie Charlie/David/Eve, last-duty
  smallest Charlie(4) → door **Charlie**; auditorium tie David/Eve(5)
  → **David** (lower position, Bob excluded).
- **M8** (weekend): Eve is the only 2-duty person → door **Eve**;
  auditorium tie Alice/Bob(6) → **Alice** (lower position).

Final counts: Alice 4, Bob 3, Charlie 3, David 3, Eve 3. Bob's three
duties are M2 (door), M4 (auditorium), M6 (auditorium) - all weekend,
never midweek - and his count is within one of everybody else's,
exactly as the design's fairness rule promises even with a block in
place.

Expected output and CSV recorded from the built program after this
check.
