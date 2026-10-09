# CLAUDE.md

Julia package implementing the VSOP87 planetary theory (Bretagnon & Francou 1988).
Currently only **version A** is implemented: heliocentric rectangular X, Y, Z in AU,
dynamical ecliptic and equinox J2000, for the eight major planets. No dependencies
beyond Base; `Test` is the only test-time extra.

## Commands

```sh
julia --project -e 'using Pkg; Pkg.test()'                  # run the test suite
julia --project -e 'using VSOP87; VSOP87A(:Earth, 2451545.0)'
```

Precompilation is slow-ish because the source is ~40k lines of unrolled series.
`Manifest.toml` is gitignored (library package) and must not be committed.

## Layout

- `src/VSOP87.jl` — module file: header docstring, the `VSOP87A(body::Symbol, jd_tt::Real)`
  dispatcher, `include`s and `export`s. This is the only hand-written source file.
- `src/VSOP87A_<Planet>.jl` — one file per planet, **machine-converted** from C++ produced by
  Jay Tanner's VSOP87 Source Code Generator. Do not reformat or hand-edit the coefficient lines.
- `test/runtests.jl` — reference positions per planet at 10 epochs, 100 years apart
  (JD 2451545 down to 2122820), compared with `≈`.
- `reference/VSOP87_AA1988.pdf` — the original paper.
- `.github/workflows/CI.yml` — tests on Julia 1.6 (minimum, matches `[compat]`) and latest
  on Linux/macOS/Windows; Codecov upload; a Documenter `docs` job exists but is disabled
  (`if: false`, no `docs/` directory yet).

## Planet file structure

Every planet file has exactly the same shape (20 functions):

```julia
function VSOP87A_<Planet>(jd_tt::Float64)
    pos = zeros(3)
    t = (jd_tt - 2451545.0 ) / 365250.0            # Julian millennia from J2000 TT
    pos[1] = <Planet>_X0(t) + ... + <Planet>_X5(t)
    pos[2] = <Planet>_Y0(t) + ... + <Planet>_Y5(t)
    pos[3] = <Planet>_Z0(t) + ... + <Planet>_Z5(t)
    return pos
end

VSOP87A_<Planet>(jd_tt::Int) = ...                 # forwards to the Float64 method

function <Planet>_X0(t::Float64) # 843 terms of order 0
    X0 = 0.0
    X0 += A*cos(B + C*t)                           # one line per term
    ...
    return X0                                      # order n returns X<n>*t^n (written as t*t*...)
end
```

If you change something structural (return type, argument types), apply it identically to
all eight files — a script (`sed`/Julia) is safer than manual edits.

## Conventions

- **Input** is a Julian Date in Terrestrial Time; the argument is named `jd_tt`
  (it used to be `YDTT`). Output is a `Vector{Float64}` of length 3 in AU.
- **Bodies** are `Symbol`s: `:Mercury :Venus :Earth :Mars :Jupiter :Saturn :Uranus :Neptune`.
- **Public API**: `VSOP87A` plus one exported `VSOP87A_<Planet>` per planet. The series
  helpers (`Earth_X0` etc.) are internal and not exported.
- **Naming**: `VSOP87<version>_<Planet>` for entry points; keep this pattern if versions
  B–E are added (e.g. `VSOP87C_Mars`, files `src/VSOP87C_Mars.jl`).
- **Indentation**: 4 spaces in planet files and tests; `src/VSOP87.jl` uses 3 spaces.
  Match the file you are editing. No tabs. Unicode (`≈`, `″`) is fine.
- **Docstrings**: plain indented text blocks in triple quotes (generator style), not
  Documenter markdown sections.
- **Tests**: one `@testset "VSOP87A_<Planet>"` per body inside an outer
  `@testset verbose=true "VSOP87A"`; one line per epoch:
  `pos = VSOP87A(:Body, jd);  @test pos ≈ [x, y, z]    # Date = ...`, values with
  explicit sign and 10 decimals. New functionality needs reference values from an
  independent source (e.g. the official VSOP87 check file `vsop87.chk`).
- **Docs**: README is English and is the user-facing documentation; keep its usage example
  in sync with the actual output.
- **Commits**: short imperative English subject lines ("Fix ...", "Add ...", "Clean up ...").

## Known caveats

- License mismatch: `LICENSE` is MIT, but the header docstring in `src/VSOP87.jl` carries
  the GPL v3 notice inherited from the C++ generator. Don't change either without asking.
- The package is not registered in the General registry yet.
