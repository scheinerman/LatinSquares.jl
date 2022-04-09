module LatinSquares
using JuMP
using MathProgBase
using Cbc
using ChooseOptimizer



include("ortho_latin.jl")
include("latin.jl")
include("latin_print.jl")

# package code goes here

end # module
