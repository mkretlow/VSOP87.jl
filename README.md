# VSOP87.jl [![Build Status](https://travis-ci.org/mkretlow/VSOP87.jl.svg?branch=master)](https://travis-ci.org/mkretlow/VSOP87.jl)

This is a Julia wrapper to the [Fortran VSOP87](https://github.com/ctdk/vsop87) implementation of the planetary solutions VSOP87.


## Install
VSOP87.jl can then be installed through Julia's package manager. On Linux and macOS you need to have either Gfortran or the Intel Fortran Compiler installed to be able to build the binary dependencies.
```julia

pkg> add "https://github.com/mkretlow/VSOP87.jl.git"
```

## Usage

```julia
julia> using VSOP87

# vsop87(tjd::Float64, ivers::Signed, ibody::Signed, prec::Float64 = 0.0)

julia> rar,ierr = vsop87(tjd, ivers, ibody, prec)
```

### Args

    tdj,ivers,ibody,prec :  Julian date, VSOP version (main,A,B,C,D,E series), body select code, preset precision

    The code ivers of the version is :
    iv = 0 for the main version VSOP87 :  Heliocentric elliptic elements J2000
    iv = 1 for the version VSOP87A     :  Heliocentric rectangular variables J2000
    iv = 2 for the version VSOP87B     :  Heliocentric spherical variables J2000
    iv = 3 for the version VSOP87C     :  Heliocentric rectangular variables of date
    iv = 4 for the version VSOP87D     :  Heliocentric spherical variables of date
    iv = 5 for the version VSOP87E     :  Barycentric rectangular variables J2000

    The codes of the bodies are :
    0 : Sun
    1 : Mercury
    2 : Venus
    3 : Earth
    4 : Mars
    5 : Jupiter
    6 : Saturn
    7 : Uranus
    8 : Neptune
    9 : Earth-Moon barycenter

    prec : Preset of desired relative precision (full or reduced precision of result).
           If prec is equal to 0.0 then the precision is the precision p0 of the
           complete solution VSOP87 (full precision). That's the default.
           Mercury    p0 =  0.6 10**-8
           Venus      p0 =  2.5 10**-8
           Earth      p0 =  2.5 10**-8
           Mars       p0 = 10.0 10**-8
           Jupiter    p0 = 35.0 10**-8
           Saturn     p0 = 70.0 10**-8
           Uranus     p0 =  8.0 10**-8
           Neptune    p0 = 42.0 10**-8

    Other values (let's say between p0 and 10^-2) are possible.
    For more details see header of deps/vsop87.f.

### Return
    rar  : 6-element Array{Float64} with results, depending on value of ivers

    ierr : Error return code
        0: no error
        1: file error (check up ivers index)
        2: file error (check up ibody index)
        3: precision error (check up prec parameter)
        4: reading file error

## Example
```julia
# Heliocentric rectangular coordinates and velocities of Earth for JD2451545.0 (2000-01-01.5 TDB):

julia> vsop87(2451545.0, 1, 3)
([-0.177135, 0.967242, -3.90003e-6, -0.0172076, -0.00315879, 1.06867e-7], 0)
```

---
