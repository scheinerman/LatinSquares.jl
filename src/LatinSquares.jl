module LatinSquares
using JuMP
using MathProgBase
using GLPK
using ChooseOptimizer



include("ortho_latin.jl")
include("latin.jl")
include("latin_print.jl")

# package code goes here

end # module
