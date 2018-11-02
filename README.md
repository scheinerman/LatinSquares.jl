# LatinSquares



[![Build Status](https://travis-ci.org/scheinerman/LatinSquares.jl.svg?branch=master)](https://travis-ci.org/scheinerman/LatinSquares.jl)

[![codecov.io](http://codecov.io/github/scheinerman/LatinSquares.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/LatinSquares.jl?branch=master)


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



<hr>

### Note

We use the Cbc solver. If you have Gurobi on your system, that solver
will run much faster.
