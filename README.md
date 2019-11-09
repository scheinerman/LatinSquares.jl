# LatinSquares


This module creates Latin squares and pairs of orthogonal Latin squares.
Where possible, simple number-theoretic constructions are used. Otherwise,
integer programming.

## Usage

To create a simple `n`-by-`n` Latin square, use `latin(n)`:
```
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
```
julia> A,B = ortho_latin(5);

julia> 10A+B
5×5 Array{Int64,2}:
 11  22  33  44  55
 23  34  45  51  12
 35  41  52  13  24
 42  53  14  25  31
 54  15  21  32  43
```
Or to see the two in Latin and Greek letters:
```
julia> print_latin(A,B)
Aα Bβ Cγ Dδ Eε
Bγ Cδ Dε Eα Aβ
Cε Dα Eβ Aγ Bδ
Dβ Eγ Aδ Bε Cα
Eδ Aε Bα Cβ Dγ
```


By default, we use a simple number-theoretic construction. When that fails,
we switch to integer programming.
```
julia> A,B = ortho_latin(4);
No quick solution. Using integer programming.

julia> 10A+B
4×4 Array{Int64,2}:
 43  11  34  22
 14  42  23  31
 32  24  41  13
 21  33  12  44
```

#### Self orthogonal Latin squares

A Latin square is *self orthogonal* provided it is orthogonal to
its transpose. Use `ortho_latin(n,true)` to create such a self
orthogonal Latin square.
```
julia> A,B = ortho_latin(5,true);

julia> 10A+B
5×5 Array{Int64,2}:
 11  54  43  32  25
 45  33  51  24  12
 34  15  22  41  53
 23  42  14  55  31
 52  21  35  13  44

julia> A==B'
true
```

#### No pair of orthogonal Latin squares of order 6

There does not exist a pair of 6-by-6 orthogonal Latin squares, and this
verifies that fact:
```
julia> A,B = ortho_latin(6);
```
However, the run time with the Cbc solver is very long. Changing the code
to use the Gurobi solver makes this calculation feasible.


## Command Line

In the `src` directory, the file `run_latin.jl` allows the user to find
orthogonal Latin squares from the command line. The synatx is
`julia run_julia.jl n`.

Long-running jobs can be conveniently sent to a file like this:
```
$ nohup julia run_latin.jl 8 > output.txt &
```

## Example

Using the Gurobi solver, we can find a pair of 10-by-10 orthogonal Latin
square in a matter of hours. Here's the result:
```
Aα Bβ Cγ Dδ Eε Fζ Gη Hθ Iι Jκ
Bγ Iδ Hζ Eθ Aη Jα Dι Cκ Fε Gβ
Gι Cε Iα Fκ Hδ Eβ Bθ Jζ Dη Aγ
Hκ Dα Fη Aβ Gγ Cθ Iε Bι Jδ Eζ
Iβ Fγ Aε Jη Dθ Gδ Cζ Eα Bκ Hι
Jε Aζ Gθ Hγ Fι Dκ Eδ Iη Cβ Bα
Dζ Eι Bδ Gα Iκ Hε Jγ Fβ Aθ Cη
Cδ Hη Eκ Bε Jβ Aι Fα Dγ Gζ Iθ
Eη Jθ Dβ Cι Bζ Iγ Aκ Gε Hα Fδ
Fθ Gκ Jι Iζ Cα Bη Hβ Aδ Eγ Dε
```

## Other Solvers

Use the `ChooseOptimizer` module to select an alternative solver.

We use the Cbc solver. If you have Gurobi on your system, that solver
will run much faster. In that case, do this to switch solver.

```
julia> using Gurobi, LatinSquares, ChooseOptimizer

julia> set_solver(Gurobi)
GurobiSolver

julia> A,B = ortho_latin(6)
No quick solution. Using integer programming.
Academic license - for non-commercial use only
Academic license - for non-commercial use only
Optimize a model with 222 rows, 1296 columns and 7782 nonzeros
Variable types: 0 continuous, 1296 integer (1296 binary)
Coefficient statistics:
  Matrix range     [1e+00, 1e+00]
  Objective range  [0e+00, 0e+00]
  Bounds range     [0e+00, 0e+00]
  RHS range        [1e+00, 1e+00]
Presolve removed 42 rows and 696 columns
Presolve time: 0.01s
Presolved: 180 rows, 600 columns, 3600 nonzeros
Variable types: 0 continuous, 600 integer (600 binary)

Root relaxation: objective 0.000000e+00, 245 iterations, 0.01 seconds

    Nodes    |    Current Node    |     Objective Bounds      |     Work
 Expl Unexpl |  Obj  Depth IntInf | Incumbent    BestBd   Gap | It/Node Time

     0     0    0.00000    0  135          -    0.00000      -     -    0s
     0     0    0.00000    0  155          -    0.00000      -     -    0s
     0     0    0.00000    0  122          -    0.00000      -     -    0s
     0     0    0.00000    0  131          -    0.00000      -     -    0s
     0     0    0.00000    0   26          -    0.00000      -     -    0s
     0     2    0.00000    0   26          -    0.00000      -     -    0s

Explored 1536 nodes (52753 simplex iterations) in 3.18 seconds
Thread count was 4 (of 4 available processors)

Solution count 0

Model is infeasible
Best objective -, best bound -, gap -
ERROR: No pair of orthogonal Latin squares of order 6 can be found.
```
