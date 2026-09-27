# Check: 09-start-date-wrong-weekday

`-d 2026-07-30` names a Thursday: 2026-07-29 is the Wednesday the design's
own worked example uses, so the very next day, 30 July, is a Thursday.
The midweek meeting day is fixed at Wednesday (weekday 3) in
`src/calendar.vox`, and `-d` must name that weekday for the *first*
midweek meeting, or the whole schedule would silently start on the
wrong day.

Expected: `scheduler: cannot read the start date` is NOT what fires here,
because `2026-07-30` does read as a moment - it is a real date. The
refusal is the weekday check: it must name the weekday the given date
actually is (Thursday) and the weekday it must be (Wednesday), so a
typo is diagnosable without a calendar in hand:

    scheduler: Thu 30 Jul 2026 is a Thursday, but the first midweek meeting must be a Wednesday

Exit code 1: this is a usage error, not a schedule with a gap in it.

Expected output and status recorded from the built program after this
check.
