#
# Build shared lib from Fortran source
#

function getcompiler()

    haskey(ENV, "FC") && return ENV["FC"]

    if success(`which ifort`)
        return "ifort"

    elseif success(`which gfortran`)
        return "gfortran"

    else
        error("No compatible Fortran compiler found.")
    end

end


function unixbuild(compiler,path,name,ext)

    if compiler == "ifort"
        run(`ifort -$(Sys.isapple() ? "dynamiclib" : "shared") -O3 -xHost -ipo -fpic -o $path/$name.$ext vsop87jul.f vsop87.f`)

    elseif compiler == "gfortran"
        run(`gfortran -$(Sys.isapple() ? "dynamiclib" : "shared") -O3 -fPIC -o $path/$name.$ext vsop87jul.f vsop87.f`)
    end

    println("Unix build finished: $path/$name.$ext")

end


function windowsbuild(path)
    error("Windows build not implemented. Sorry.")
end


# Main starts here:

compiler = Sys.isunix() ? getcompiler() : ""

path = dirname(@__FILE__)

name = "libvsop87"

ext = Sys.isapple() ? "dylib" : "so"

build() = Sys.isunix() ? unixbuild(compiler,path,name,ext) : windowsbuild(path,name)

build()
