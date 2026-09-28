# Shared check: the header line, after "the run starts at the first meeting"

`src/calendar.vox` now names the first meeting's moment `'the first
meeting moment'` (was `'the first midweek moment'`) and the header
`scheduler.vox` prints changed to match: `First meeting: <long date>
<kind>` instead of `First midweek meeting: <long date>`, since the run
may now start with either kind of meeting. No other part of any
schedule case's behaviour changed - the assignment rule, the
week/date/CSV values, and every count in each case's own `CHECK.md`
walk are all untouched, because every one of these cases starts on
2026-07-29, a Wednesday, so `'meeting is at the weekend'` still marks
the same meeting numbers as weekend meetings it always did.

Below is the exact `diff -u` between each affected case's old and new
`expected.out`, confirming that header line is the only change. Two
are shown in full as representative; the rest differ from their own
prior `expected.out` in exactly the same single line, substituting
each case's own `People:`/`Weeks:`/`Availability:` values (already
present unchanged on the surrounding lines) for the header:

```diff
--- a/tests/cases/01-five-people-four-weeks/expected.out
+++ b/tests/cases/01-five-people-four-weeks/expected.out
@@ -2,7 +2,7 @@ Duty schedule
 =============
 People: 5
 Weeks: 4
-First midweek meeting: Wed 29 Jul 2026
+First meeting: Wed 29 Jul 2026 midweek
 Availability: no grid at availability.csv, everyone is available

 Week 1
```

```diff
--- a/tests/cases/06-two-people-one-week/expected.out
+++ b/tests/cases/06-two-people-one-week/expected.out
@@ -2,7 +2,7 @@ Duty schedule
 =============
 People: 2
 Weeks: 1
-First midweek meeting: Wed 29 Jul 2026
+First meeting: Wed 29 Jul 2026 midweek
 Availability: no grid at availability.csv, everyone is available

 Week 1
```

The full list of cases re-recorded under this one-line rule, each
verified the same way (`diff -u` against the previous `expected.out`
shows only the header line changed, `expected.status` and
`expected.csv` where present are byte-identical to before):

- `01-five-people-four-weeks`
- `02-one-person-blocked-midweek`
- `03-header-in-different-order`
- `04-unknown-and-missing-names`
- `05-no-header`
- `06-two-people-one-week`
- `07-unfillable`
- `10c-crlf-names`
- `11-short-and-long-rows`
- `12b-schedule-with-contact-detail`

`09b-start-date-relative` also gets this same header change, but has
its own `CHECK.md` note (it already had one to update, for the
renamed `'the first meeting moment typed as'`). `09-start-date-wrong-weekday`
is not a header change at all - its refusal message itself changed
wording, per its own `CHECK.md`. `00-help` and `00b-version` are not
schedule runs and are covered by their own `CHECK.md` files.
