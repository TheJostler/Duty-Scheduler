# Check: 06-two-people-one-week

Two names, no grid, `-w 1` gives 2 meetings (midweek + weekend). This
is the smallest roster the program accepts (fewer than two is refused
per Task 2's `10-one-name` case), and it pins down the "not already on
duty this meeting" exclusion: with only two people, the door pick
*must* exclude itself from the auditorium pick, or the same person
would hold both slots in one meeting.

- **M1 door**: both tied at 0 duties, 0 last-duty → lowest position →
  **Alice**. **M1 auditorium**: Alice is excluded (already the door
  holder this meeting) even though she is still tied on every other
  measure → **Bob** by elimination, not by the rule's ranking.
  Counts: Alice1 Bob1.
- **M2 door**: both tied at 1 duty, 1 last-duty (both did their one
  duty at meeting 1) → lowest position → **Alice** again. **M2
  auditorium**: Alice excluded → **Bob** again.
  Final counts: Alice2 Bob2.

Door and auditorium are different people in both meetings, no slot is
unfilled, and the two-person tie never breaks by anything other than
the exclusion rule and names-file order, since both people are
identical on every count going in.

Expected output and CSV recorded from the built program after this
check.
