# Notes for the master

Things that couldn't be done exactly as written, or that the language
sprang on this project beyond the plan's own "Traps" list. None of
these changed scope; each is a workaround or a corrected reading, not
a silent reduction.

## Plan inconsistency: `'the label of meeting'`'s date format (Task 4)

The plan's interface bullet for `'the label of meeting'`
(`docs/superpowers/plans/2026-09-27-duty-scheduler-rewrite.md`, the
Task 2 Interfaces list) says the label is "built from the long date
and the kind" - implying `%a %e %b %Y`, the space-padded-day format
used for the terminal's week lines (`Sun  2 Aug 2026`, two spaces).

But the plan's own byte-exact examples disagree: the help text's grid
example (`Sun 2 Aug 2026 weekend,0,0,0`, one space) and the empty-grid
description both show the *non*-padded day. I followed the byte-exact
example over the prose description - the same priority the plan
itself gives worked examples elsewhere - and changed
`'the label of meeting'` to use `%a %-d %b %Y` instead. This only
differs from the original wording for single-digit days; no
already-recorded case exercised it with one, so nothing needed
re-recording. See `src/calendar.vox`.

## Language traps not in the plan's list

- **A comparison (`X is Y`, `X is greater than Y`, ...) cannot be the
  value of a declaration or a `Set ... to`.** `a boolean called b is x
  is y.` and `Set b to x is y.` are both compile errors ("Expected a
  statement, got Is"); the comparison is only valid inside `Return`,
  an `if`/`while` condition, or similar. Worked around by inlining
  conditions directly rather than pre-computing boolean locals.
- **ANDing two function-call conditions in one `if` needs each call
  braced.** `if f of x and g of y and z then` mis-parses: `and` binds
  into the *first* call's own argument list. Brace each call:
  `if {f of x} and {g of y and z} then`.
- **Reassigning an existing `text` variable with a format string
  needs `Set ... to ...`, not `the X is "...{...}..."`.** The latter
  fails with "Format-string assignment requires a buffer destination"
  - apparently only a *fresh declaration* (or a buffer) may be
    written with a format string; an existing text variable's
    reassignment must go through `Set`. Affects any global text
  re-set from more than one branch (e.g. `'the availability note'`).
- **A period inside a loop closes only the loop's own nested `if`,
  not the loop** - documented, but its consequence for a *guard
  clause with an early `Return`* is easy to miss: `For each x in xs, if
  cond then, Return true.` followed by an unconditional `Return
  false.` on the next line silently absorbs that `Return false.` into
  the loop body, so it fires after the *first* iteration's `if` falls
  through, never checking later items. Needs a second period
  (`Return true..`) to close the loop before the fallback `Return`.
  The mirror case - an `if`/`otherwise` whose last branch action is
  itself a nested `for each` or `if` - does *not* have this problem:
  the compiler recognises the whole `if`/`otherwise` as complete once
  that nested construct's own period fires, and a following bare
  statement runs unconditionally either way. Verified by direct test
  in both directions; see the worker's scratch notes if this needs
  re-deriving.
- **Byte access (`byte N of ...`) requires a `buffer`, not a `text`.**
  To read a text's first byte (used to tell a header row from a data
  row), copy it into a buffer first: `a buffer called b is
  sometext.` then `byte 1 of b`.

## Interfaces section is prose, not literal syntax, in places

Several Interfaces bullets across Tasks 2-4 read like one-line Vox
(`To 'f' with .... Return a number.`), but the actual grammar puts
`Return a <type>, <expr>.` inside the function *body*, not on the
signature line - a signature line ending in `Return a number.` with
no expression is a compile error. Every function in this codebase
follows the real grammar (signature ends after parameters; the body's
last statement is the `Return`); the bullets should be read as "this
function returns a number", not copied character-for-character.

## Master's deferred style items (not yet applied)

Per steer messages during Tasks 3 and 4, these are intentionally left
for the Task 5 style pass rather than fixed piecemeal:

1. `the 'the X' is Y` reads as "the the" - use `Set 'the X' to Y`.
   Known spots: `scheduler.vox:51`, `duties.vox`, `report.vox`, and
   the several new ones this task added in `availability.vox` (which
   *do* use `Set`, per the master's guidance and the format-string
   trap above - so `availability.vox` needs no fix here).
2. Test text emptiness with `is empty`/`is not empty`, not `is ""`.
   Known spots: `roster.vox:17`, `calendar.vox:53`. `availability.vox`
   was written using `is empty`/`is not empty` throughout per the
   guidance, so it needs no fix here either.
3. Optional: `'the holder text for'` -> `'the holder text'`,
   `'record a duty for'` -> `'record a duty'` (the call word already
   supplies the preposition).
