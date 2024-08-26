module LatinSquares
using JuMP
# using MathProgBase
using ChooseOptimizer

function __init__()
    set_solver_verbose(false)
end

include("ortho_latin.jl")
include("latin.jl")
include("latin_print.jl")

# package code goes here

end # module
