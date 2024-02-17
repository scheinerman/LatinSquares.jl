module LatinSquares
using JuMP
using MathProgBase
using GLPK
using ChooseOptimizer

set_solver(GLPK)

include("ortho_latin.jl")
include("latin.jl")
include("latin_print.jl")

# package code goes here

end # module
