# Check: 09b-start-date-relative

`-d "next wednesday"` is what a person would actually type, but its
answer depends on today's date, so it cannot be recorded as a stable
expected output. `"2026-07-22 + 1 week"` is the plan's stand-in: an
*absolute* relative-description form the date library's relative
parser still reads (`'reads as a description'` is true for it, and it
does not depend on `now`), landing on 2026-07-29 - the same Wednesday
the design's worked example uses.

This case exists to prove the second branch of
`'the first midweek moment typed as'` fires: the text does not
`'reads as a moment'` on its own (it is not a plain date), so the
function falls through to `'reads as a description'`, which is true,
and resolves via `'the moment described by'`.

Expected: the header's "First midweek meeting" line reads
`Wed 29 Jul 2026`, and the run completes normally (status 0) since
29 July is a Wednesday, matching the midweek meeting day.

Expected output and status recorded from the built program after this
check.
