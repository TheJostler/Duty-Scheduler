# Check: 07-unfillable

Two people, one week. Bob is blocked at every meeting, so once Alice
takes the door slot, nobody at all is left for auditorium: Bob is
blocked and Alice already holds the other slot this meeting. This is
the smallest case that can produce an `UNFILLED` slot.

- **M1** (midweek): door - both tied at 0/0, lowest position → **Alice**.
  auditorium - only remaining candidate is Bob, who is blocked →
  **UNFILLED**.
- **M2** (weekend): door - Alice has 1 duty, Bob still blocked, so
  Alice is the only eligible candidate regardless of count → **Alice**
  again. auditorium - Bob blocked again → **UNFILLED**.

Final counts: Alice 2, Bob 0. Two unfilled slots, both auditorium,
each naming its meeting's label and "nobody is available". Status is
0: an unfilled slot is not a program error, the design says the
schedule "still completes". The CSV's Auditorium column holds
`UNFILLED` for both rows.

Expected output and CSV recorded from the built program after this
check.
