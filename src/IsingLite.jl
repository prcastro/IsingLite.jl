module IsingLite

using PyPlot

export neighbors,
       nspins,
       spingrid,
       namefunc,
       heatbath!,
       metropolis!,
       wolff!,
       diagram

include("utils.jl")
include("heatbath.jl")
include("metropolis.jl")
include("wolff.jl")

end # module
