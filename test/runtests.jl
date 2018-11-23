using Test
using VSOP87


# Testing
@testset "VSOP87 A-Series" begin

    pv,ierr = vsop87(2122820.0,1,1,0.0)
    #@test ierr == 0
    @test pv ≈ [.2146329139 , -.3752296250 , -.0503982597 , .0188319750 , .0155086039 , -.0005235332 ] atol=1E-10

    pv,ierr = vsop87(2451545.0,1,1,0.0)
    #@test ierr == 0
    @test pv ≈ [-.1300934115 , -.4472876716 , -.0245983802 , .0213663982 , -.0064479797 , -.0024878668] atol=1E-10

end
