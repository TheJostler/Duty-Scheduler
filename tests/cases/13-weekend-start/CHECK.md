# Check: 13-weekend-start

`-d 2026-10-04` names a Sunday, so the run starts with a weekend
meeting instead of the usual midweek one: `'the first meeting moment
typed as'` accepts it (Sunday is `'the weekend meeting day'`) and sets
`'the run starts at the weekend'` to true. `-w 2` gives 4 meetings, no
grid, so everyone is always free.

**Calendar check.** With the run starting at the weekend, `'meeting is
at the weekend'` now calls the *odd* meeting numbers (1, 3) weekend
ones, so:

- Meeting 1 (week 1, first of the week): moment is `'the first meeting
  moment'` itself, kind weekend → Sun 4 Oct 2026 weekend.
- Meeting 2 (week 1, second of the week): the gap from the first
  kind's day to the other kind's day is `((3 subtract 7) add 7) modulo
  7` = 3, so 4 Oct + 3 days = 7 Oct → Wed 7 Oct 2026 midweek.
- Meeting 3 (week 2, first of the week): `'weeks later'` of the first
  meeting moment and 1 week → 4 Oct + 7 = 11 Oct → Sun 11 Oct 2026
  weekend.
- Meeting 4 (week 2, second of the week): 11 Oct + the same 3-day gap
  = 14 Oct → Wed 14 Oct 2026 midweek.

This matches the brief's own worked example: Wednesday to Sunday is a
4-day gap, Sunday to Wednesday is a 3-day gap, and neither number is
hard-coded - both come from `((other day subtract first day) add 7)
modulo 7` with the two meeting-day constants as the operands.

**Assignment check.** The rule (fewest duties, then longest since last
duty, then file order) does not look at what kind a meeting is, only
at its position in the sequence 1..4, so these four meetings are
assigned exactly like the first four of `01-five-people-four-weeks`
(same five names, same order, no grid there either):

- **M1 door**: all tied at 0 duties, 0 last-duty → lowest position →
  **Alice**. **M1 auditorium**: exclude Alice; all others tied →
  **Bob**. Counts: Alice1 Bob1 Charlie0 David0 Eve0.
- **M2 door**: fewest duties is 0, tied Charlie/David/Eve → lowest
  position → **Charlie**. **M2 auditorium**: exclude Charlie; fewest 0,
  tied David/Eve → **David**. Counts: Alice1 Bob1 Charlie1 David1 Eve0.
- **M3 door**: fewest duties is 0, only Eve → **Eve**. **M3
  auditorium**: exclude Eve; all four tied at 1 duty; last-duty tied at
  1 for Alice/Bob (Charlie/David are 2) → lowest position → **Alice**.
  Counts: Alice2 Bob1 Charlie1 David1 Eve1.
- **M4 door**: fewest duties is 1, tied Bob/Charlie/David/Eve;
  last-duty smallest is Bob (1, vs Charlie2/David2/Eve3) → **Bob**.
  **M4 auditorium**: exclude Bob; fewest 1 tied Charlie/David/Eve;
  last-duty smallest tied Charlie/David (2, Eve is 3) → lowest position
  → **Charlie**. Final counts: Alice2 Bob2 Charlie2 David1 Eve1.

No slot is ever unfilled (5 people, 2 needed per meeting, everyone
free), exit code 0.

Expected output and CSV recorded from the built program after this
check.
