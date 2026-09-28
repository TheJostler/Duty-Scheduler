# Check: 09-start-date-wrong-weekday

`-d 2026-07-30` names a Thursday: 2026-07-29 is the Wednesday the design's
own worked example uses, so the very next day, 30 July, is a Thursday.
The meeting days are fixed at Wednesday (weekday 3) and Sunday
(weekday 7) in `src/calendar.vox`, and `-d` must name one of those two
weekdays for the *first* meeting, or the whole schedule would silently
start on the wrong day.

Expected: `scheduler: cannot read the start date` is NOT what fires here,
because `2026-07-30` does read as a moment - it is a real date. The
refusal is the weekday check: it must name the weekday the given date
actually is (Thursday) and the two weekdays a meeting may start on
(Wednesday, Sunday), so a typo is diagnosable without a calendar in
hand:

    scheduler: Thu 30 Jul 2026 is a Thursday, but a meeting is on a Wednesday or a Sunday

Exit code 1: this is a usage error, not a schedule with a gap in it.

Expected output and status recorded from the built program after this
check.
