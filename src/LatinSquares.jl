module LatinSquares
using JuMP
using MathProgBase
using Cbc

SOLVER = CbcSolver


export set_latin_solver

function set_latin_solver(sol)
    global SOLVER = sol
end

include("ortho_latin.jl")
include("latin.jl")
include("latin_print.jl")

# package code goes here

end # module
