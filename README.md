# VSOP87.jl

This is a Julia wrapper to the [Fortran VSOP87](https://github.com/ctdk/vsop87) implementation of the planetary solutions VSOP87. 

# Usage

```julia

julia> Pkg.add("https://github.com/mkretlow/VSOP87.jl.git")
julia> Pkg.build(VSOP87)

julia> rar = vsop87(tjd::Float64, ivers::Signed, ibody::Signed, prec::Float64)
```
## Args

    tdj,ivers,ibody,prec :  Julian date, VSOP version (main,A,B,C,D,E series), body select code, preset precision

    The code ivers of the version is :
    iv = 0 for the main version VSOP87 :  Heliocentric elliptic elements J2000
    iv = 1 for the version VSOP87A     :  Heliocentric rectangular variables J2000
    iv = 2 for the version VSOP87B     :  Heliocentric spherical variables J2000
    iv = 3 for the version VSOP87C     :  Heliocentric rectangular variables of date
    iv = 4 for the version VSOP87D     :  Heliocentric spherical variables of date
    iv = 5 for the version VSOP87E     :  Barycentric rectangular variables J2000

    The codes of the bodies are :
    1 : Mercury
    2 : Venus
    3 : Earth for the versions A-E and Earth-Moon Barycenter for the main version
    4 : Mars
    5 : Jupiter
    6 : Saturn
    7 : Uranus
    8 : Neptune
    9 : Earth-Moon barycenter for the version A and Sun for the version E.


## Return
    rar  : 6-element Array{Float64} with results, depending on value of ivers

    ierr : Error return code
        0: no error
        1: file error (check up ivers index)
        2: file error (check up ibody index)
        3: precision error (check up prec parameter)
        4: reading file error
