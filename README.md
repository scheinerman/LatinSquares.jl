# LatinSquares

[![Build Status](https://travis-ci.org/scheinerman/LatinSquares.jl.svg?branch=master)](https://travis-ci.org/scheinerman/LatinSquares.jl)

[![Coverage Status](https://coveralls.io/repos/scheinerman/LatinSquares.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/scheinerman/LatinSquares.jl?branch=master)

[![codecov.io](http://codecov.io/github/scheinerman/LatinSquares.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/LatinSquares.jl?branch=master)

This module will create Latin square and pairs of orthogonal Latin squares.
Where possible, simple number-theoretic constructions are used. Otherwise,
we use Gurobi to solve an integer program.

## Usage

To create a simple `n`-by-`n` Latin square, use `latin(n)`:
```julia
julia> using LatinSquares

julia> latin(5)
5×5 Array{Int64,2}:
 1  2  3  4  5
 2  3  4  5  1
 3  4  5  1  2
 4  5  1  2  3
 5  1  2  3  4
```

To create a pair of `n`-by-`n` orthogonal Latin squares, use `ortho_latin(n)`.
```julia
julia> A,B = ortho_latin(5);

julia> 10A+B
5×5 Array{Int64,2}:
 11  22  33  44  55
 23  34  45  51  12
 35  41  52  13  24
 42  53  14  25  31
 54  15  21  32  43
```

By default, we use a simple number-theoretic construction. When that fails,
we then result to integer programming.
```julia
julia> A,B = ortho_latin(4);
Academic license - for non-commercial use only
Optimize a model with 3984 rows, 128 columns and 15792 nonzeros
Variable types: 0 continuous, 128 integer (128 binary)
Coefficient statistics:
  Matrix range     [1e+00, 1e+00]
  Objective range  [0e+00, 0e+00]
  Bounds range     [1e+00, 1e+00]
  RHS range        [1e+00, 3e+00]
Presolve removed 3984 rows and 128 columns
Presolve time: 0.00s
Presolve: All rows and columns removed

Explored 0 nodes (0 simplex iterations) in 0.00 seconds
Thread count was 1 (of 4 available processors)

Solution count 1: 0

Optimal solution found (tolerance 1.00e-04)
Best objective 0.000000000000e+00, best bound 0.000000000000e+00, gap 0.0000%

julia> 10A+B
4×4 Array{Int64,2}:
 11  22  33  44
 24  13  42  31
 32  41  14  23
 43  34  21  12
```

There does not exist a pair of 6-by-6 orthogonal Latin squares, and this
verifies that fact:
```julia
julia> A,B = ortho_latin(6);
Academic license - for non-commercial use only
Optimize a model with 45684 rows, 432 columns and 182844 nonzeros
Variable types: 0 continuous, 432 integer (432 binary)
Coefficient statistics:
  Matrix range     [1e+00, 1e+00]
  Objective range  [0e+00, 0e+00]
  Bounds range     [1e+00, 1e+00]
  RHS range        [1e+00, 3e+00]
Presolve removed 43494 rows and 182 columns
Presolve time: 0.06s
Presolved: 2190 rows, 250 columns, 8400 nonzeros
Variable types: 0 continuous, 250 integer (250 binary)
Presolved: 250 rows, 2440 columns, 8650 nonzeros


Root relaxation: objective 0.000000e+00, 618 iterations, 0.02 seconds

    Nodes    |    Current Node    |     Objective Bounds      |     Work
 Expl Unexpl |  Obj  Depth IntInf | Incumbent    BestBd   Gap | It/Node Time

     0     0    0.00000    0  114          -    0.00000      -     -    0s
     0     0    0.00000    0  117          -    0.00000      -     -    0s
     0     0    0.00000    0   96          -    0.00000      -     -    0s
     0     0    0.00000    0  123          -    0.00000      -     -    0s
     0     0    0.00000    0  131          -    0.00000      -     -    0s
     0     0    0.00000    0  130          -    0.00000      -     -    0s
     0     0    0.00000    0  118          -    0.00000      -     -    0s
     0     0    0.00000    0  116          -    0.00000      -     -    0s
     0     0    0.00000    0  116          -    0.00000      -     -    0s
     0     2    0.00000    0  104          -    0.00000      -     -    0s
  5914   105    0.00000   10   68          -    0.00000      -  16.1    5s

Explored 6967 nodes (147943 simplex iterations) in 7.46 seconds
Thread count was 4 (of 4 available processors)

Solution count 0

Model is infeasible
Best objective -, best bound -, gap -
WARNING: Not solved to optimality, status: Infeasible
WARNING: Infeasibility ray (Farkas proof) not available
WARNING: Variable value not defined for component of X. Check that the model was properly solved.
WARNING: Variable value not defined for component of Y. Check that the model was properly solved.
```

<hr>
### Note
We use the Gurobi solver. If that's not available on your system, edit the
files to use another (such as the CBC solver).
