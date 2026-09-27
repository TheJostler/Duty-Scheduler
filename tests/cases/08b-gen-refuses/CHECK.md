# Check: 08b-gen-refuses

Same command as `08-gen-fresh`, but this case directory *already has*
an `availability.csv` - a person's hand-typed availability, the design
says explicitly it must never be overwritten by a bare `-g`.

Expected: `path is available` is true, so the program refuses before
opening the file for writing at all:

    scheduler: availability.csv already exists, not overwriting it

Exit code 1 (a usage error, not a completed run), and the grid file's
bytes must be identical to what this case started with - the
deliberately odd fixture (`0,1,0` / `1,0,0`, not the all-zero pattern
`08-gen-fresh` produces) exists specifically so an accidental overwrite
would be obvious in the diff, not indistinguishable from a correct
"fresh" grid.

Expected output and status recorded from the built program after this
check; `expected.grid` is a copy of the fixture itself, proving the
harness's own diff step (`expected.grid` against the post-run
`availability.csv`) finds no difference.
