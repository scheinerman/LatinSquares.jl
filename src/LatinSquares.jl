module LatinSquares
using JuMP
using MathProgBase
using Cbc
using ChooseOptimizer

SOLVER = CbcSolver


export set_latin_solver


include("ortho_latin.jl")
include("latin.jl")
include("latin_print.jl")

# package code goes here

end # module
