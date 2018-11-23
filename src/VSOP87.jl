# ==================================================================================================================================
# Package: VSOP87 : Mike Kretlow [github.com/mkretlow and astrodynamics.de], Start 2018, (MIT License)
# ==================================================================================================================================

module VSOP87

using Libdl
using Printf

export vsop87


# Load shared library

const lib = find_library(["libvsop87"],["deps", joinpath(dirname(@__FILE__), "..", "deps")])

if isempty(lib)
	error("Could not find shared library")
end

@info("Using shared library $lib")


"""*********************************************************************************************************************************
   `rar,ierr = vsop87(tjd::Float64, ivers::Signed, ibody::Signed, prec::Float64 = 0.0)`

    Calculate VSOP87 values by calling original Fortran implementation.

The VSOP87 files contain the VSOP87 analytical solutions of the motion
of the planets Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus,
Neptune and Earth-Moon Barycenter.

There are six different versions of the theory VSOP87 which may be recognized
by the type of coordinates and the reference frame.

The main version VSOP87 consists of the series in elliptic elements as in the
case of previous solution VSOP82 and the other versions VSOP87 are built in
*ecliptical* rectangular variables (versions A,C,E) or spherical variables (versions B,D).

The reference frame is defined by the dynamical equinox and ecliptic J2000 for
the main version VSOP87 and the versions A, B, E, and by the dynamical equinox
and ecliptic of the date for the versions C and D.


## Args

    tdj,ivers,ibody,prec :  Julian date, VSOP version (main,A,B,C,D,E series), body select code,
    preset of relative precision

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

    prec : Preset of desired relative precision (full or reduced precision of result).
           If prec is equal to 0.0 then the precision is the precision p0 of the
           complete solution VSOP87 (full precision). That's the default.
           For more details see header of deps/vsop87.f.


## Return
    rar  : 6-element Array{Float64} with results, depending on value of ivers

    ierr : Error return code
        0: no error
        1: file error (check up ivers index)
        2: file error (check up ibody index)
        3: precision error (check up prec parameter)
        4: reading file error


## Reference

Bretagnon P., Francou G., : 1988, Astron. Astrophys., 202, 309.

See also:
- ftp://cdsarc.u-strasbg.fr/pub/cats/VI/81/ReadMe
- https://github.com/ctdk/vsop87
*********************************************************************************************************************************"""
function vsop87(tjd::Float64, ivers::Signed, ibody::Signed, prec::Float64 = 0.0)

    path = dirname(VSOP87.lib)
    plen = convert(Int32,length(path))

    ierr = Ref{Signed}(0)
    rar  = zeros(Float64,6)

    ccall((:vsop87jul_,lib),Nothing,(Ptr{Cchar},Ref{Int32},Ref{Float64},Ref{Signed},Ref{Signed},Ref{Float64},Ref{Float64},Ref{Signed}),
                                     path,plen,tjd,ivers,ibody,prec,rar,ierr)

    if (ierr[] < 0) @warn("Cannot open VSOP87x.xxx file") end

    return rar,ierr[]

end

end # module


#==================================================================================================================================#
