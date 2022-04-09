using LatinSquares, ChooseOptimizer, Gurobi

set_solver(Gurobi)
set_solver_verbose(false)

if length(ARGS) == 0
    println("Usage: julia run_latin n")
    exit()
end
n = parse(Int,ARGS[1])
println("n = $n")
println("Starting up")


@time try
    A, B = ortho_latin(n)
    println("A = $A")
    println("B = $B")
    print_latin(A,B)
catch
    println("There is no pair of orthogonal Latin square of order $n")
end
