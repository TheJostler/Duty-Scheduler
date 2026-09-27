# Vox traps not covered elsewhere

Things this program's author ran into that are not in `LANGUAGE.md`'s
own trap list or `docs/STYLE.md`. Written for whoever next writes Vox
against this compiler version.

## A comparison cannot be the value of a declaration or a `Set ... to`

`a boolean called b is x is y.` and `Set b to x is y.` are both
compile errors ("Expected a statement, got Is"). A comparison (`is`,
`is not`, `is greater than`, ...) is only valid inside `Return`, an
`if`/`while` condition, or a similar comparison-aware position - not
as the general value slot a declaration or `Set` reads.

Work around it by inlining the condition directly (`if x is y then,
...`) rather than pre-computing a boolean local from the comparison.

## ANDing two function-call conditions in one `if` needs each call braced

`if f of x and g of y and z then` mis-parses: the `and` after `f of x`
is read as part of *`f`'s own argument list*, not as the logical
connective joining two conditions. Brace each call to make the
boundary explicit:

```vox
if {f of x} and {g of y and z} then, ...
```

## Reassigning an existing `text` variable with a format string needs `Set`

```vox
a text called note is "".
the note is "processed {path}".      (compile error: "Format-string
                                        assignment requires a buffer
                                        destination")
Set note to "processed {path}".      (works)
```

Only a *fresh declaration* (`a text called x is "{...}".`) or a
`buffer` may be written with a format string directly; reassigning an
already-declared `text` variable with one must go through `Set ...
to ...` instead of `the X is ...`. This affects any global `text`
that gets re-set with interpolation from more than one branch.

## A loop's guard-clause `if` needs its own closing period before a fallback statement

A period inside a loop closes only the loop's own nested `if`, not the
loop itself - this part is in `LANGUAGE.md`. The consequence that is
easy to miss: a guard clause with an early `Return`, followed by an
unconditional fallback on the next line, silently absorbs that
fallback into the loop body:

```vox
To 'contains' with a list called items and a text called target.
  For each item in items,
    if item is target then, Return a boolean, true.
  Return a boolean, false.
```

Here `Return a boolean, false.` is *inside* the still-open `for each`
(only the `if` was closed by the first period), so it fires
unconditionally after the first iteration's `if` falls through -
`contains` returns `false` after checking only the first item, never
looking at the rest. It needs a second period to close the loop before
the fallback:

```vox
    if item is target then, Return a boolean, true..
  Return a boolean, false.
```

The mirror case does *not* have this problem: an `if`/`otherwise`
whose last branch's action is itself a nested `for each` or `if`
closes the whole `if`/`otherwise` correctly once that nested
construct's own period fires, and a bare statement on the next line
runs unconditionally regardless of which branch was taken. The
absorption risk above is specific to loops (`for each`, `while`,
`repeat`), which have no `if`/`otherwise`-style "is this construct
actually done" recognition - only period-counting.

## Byte access needs a `buffer`, not a `text`

`byte N of ...` requires a `buffer` variable; a `text` variable gives
"Byte access target must be a buffer". To read a text's first byte
(for example, to tell a header row from a data row by its leading
character), copy it into a buffer first:

```vox
a buffer called b is sometext.
a number called first is byte 1 of b.
```

## A design doc's function-signature bullets may be prose, not literal syntax

A spec or plan written as e.g. `` `To 'f' with a number called x.
Return a number.` `` reads like one line of Vox, but the real grammar
puts `Return a <type>, <expr>.` inside the function's *body*, never
appended to the signature line with no expression - a signature ending
in `Return a number.` and nothing else is a compile error. Read such a
bullet as "this function takes X and returns a number", and write the
function with the signature ending after its parameters and the
actual `Return` statement as the last line of the body.
