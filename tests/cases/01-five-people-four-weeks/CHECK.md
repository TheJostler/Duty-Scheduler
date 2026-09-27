# Check: 01-five-people-four-weeks

Five names, no grid (everyone always free), `-w 4` gives 8 meetings.
The rule for each slot: among the free, not-already-on-duty-this-meeting
people, pick fewest duty count; tie-break by longest since last duty
(never counts as longest, i.e. 0 wins); tie-break by earliest position
in `names.txt` (Alice=1, Bob=2, Charlie=3, David=4, Eve=5).

Walking all eight slots by hand (count / last-duty-meeting shown after
each slot, `-` meaning never):

- **M1 door**: all tied at 0 duties, 0 last-duty → lowest position →
  **Alice**. **M1 auditorium**: exclude Alice; all others tied → **Bob**.
  Counts: Alice1 Bob1 Charlie0 David0 Eve0. Last: Alice1 Bob1.
- **M2 door**: fewest duties is 0, tied Charlie/David/Eve → lowest
  position → **Charlie**. **M2 auditorium**: exclude Charlie; fewest 0,
  tied David/Eve → **David**.
  Counts: Alice1 Bob1 Charlie1 David1 Eve0. Last: +Charlie2 David2.
- **M3 door**: fewest duties is 0, only Eve → **Eve**. **M3 auditorium**:
  exclude Eve; all four tied at 1 duty; last-duty tied at 1 for
  Alice/Bob (Charlie/David are 2) → lowest position → **Alice**.
  Counts: Alice2 Bob1 Charlie1 David1 Eve1. Last: +Eve3 Alice3.
- **M4 door**: fewest duties is 1, tied Bob/Charlie/David/Eve;
  last-duty smallest is Bob (1, vs Charlie2/David2/Eve3) → **Bob**.
  **M4 auditorium**: exclude Bob; fewest 1 tied Charlie/David/Eve;
  last-duty smallest tied Charlie/David (2, Eve is 3) → lowest position
  → **Charlie**.
  Counts: Alice2 Bob2 Charlie2 David1 Eve1. Last: +Bob4 Charlie4.
- **M5 door**: fewest duties is 1, tied David/Eve; last-duty smallest
  is David (2, Eve is 3) → **David**. **M5 auditorium**: exclude
  David; fewest is 1, only Eve → **Eve**.
  Counts: Alice2 Bob2 Charlie2 David2 Eve2 (all tied). Last: +David5 Eve5.
- **M6 door**: all five tied at 2 duties; last-duty smallest is Alice
  (3, vs Bob4/Charlie4/David5/Eve5) → **Alice**. **M6 auditorium**:
  exclude Alice; last-duty smallest tied Bob/Charlie (4, David/Eve are
  5) → lowest position → **Bob**.
  Counts: Alice3 Bob3 Charlie2 David2 Eve2. Last: +Alice6 Bob6.
- **M7 door**: fewest duties is 2, tied Charlie/David/Eve; last-duty
  smallest is Charlie (4, David/Eve are 5) → **Charlie**. **M7
  auditorium**: exclude Charlie; fewest 2 tied David/Eve; last-duty
  tied at 5 → lowest position → **David**.
  Counts: Alice3 Bob3 Charlie3 David3 Eve2. Last: +Charlie7 David7.
- **M8 door**: fewest duties is 2, only Eve → **Eve**. **M8
  auditorium**: exclude Eve; all four tied at 3 duties; last-duty
  smallest tied Alice/Bob (6, Charlie/David are 7) → lowest position →
  **Alice**.
  Final counts: Alice4 Bob3 Charlie3 David3 Eve3.

No slot is ever left unfilled (5 people, 2 needed per meeting, everyone
free), and the final spread (4, 3, 3, 3, 3) differs by at most one, as
the design's fairness rule promises. Weekday/date/CSV values follow
directly from `-d 2026-07-29` (a Wednesday) via the calendar rule
already checked in Task 2.

Expected output and CSV recorded from the built program after this
check.
