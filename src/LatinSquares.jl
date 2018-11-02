module LatinSquares
using JuMP
using MathProgBase
using Cbc

SOLVER = CbcSolver

include("ortho_latin.jl")
include("latin.jl")
include("latin_print.jl")

# package code goes here

end # module
