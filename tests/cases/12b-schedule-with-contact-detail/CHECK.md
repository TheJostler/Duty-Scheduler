# Check: 12b-schedule-with-contact-detail

Same `names.txt` as `12-names-with-contact-detail`: five lines of
`<name>:\t<fictional phone number>`. This time a grid is present, with
its header being the five **bare** names in roster order and blocking
Bob at meeting 1 (midweek):

    Meeting,Alice,Bob,Charlie,David,Eve
    Wed 29 Jul 2026 midweek,0,1,0,0,0
    Sun 2 Aug 2026 weekend,0,0,0,0,0

Because the header carries no colon or phone number, it matches the
roster's parsed names exactly - no "in the grid but not in the names
file" or "has no column" warning for anyone. `-w 1 -d 2026-07-29`, one
week, two meetings (M1 midweek, M2 weekend).

- **M1** (Bob blocked): eligible {Alice,Charlie,David,Eve}, all tied
  at 0 duties/never had one -> door **Alice** (lowest position),
  auditorium **Charlie** (next-lowest, Alice now excluded as
  already-on-duty). Bob does not appear anywhere in M1.
- **M2** (everyone free): duty counts are Alice 1, Bob 0, Charlie 1,
  David 0, Eve 0. Fewest-duty tie {Bob,David,Eve} -> door **Bob**
  (lowest position among the tied); auditorium tie {David,Eve} (Bob
  now excluded as already-on-duty) -> **David**.

Summary: Alice, Bob, Charlie, David each hold 1 duty, Eve holds 0 -
same distribution as case `03-header-in-different-order`, whose
`names.txt` is this same five-name roster, so the summary block and
header lines are byte-identical to that case's.

Expected: every name in the schedule and the CSV is bare (`Alice`,
`Bob`, ... - never `Alice:` or a phone number), no warnings block
appears, Bob is absent from meeting 1's door and auditorium, and the
run completes with status 0.

Expected output and CSV recorded from the built program after this
check.
