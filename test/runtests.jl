using LatinSquares
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
A,B = ortho_latin(4)
@test check_ortho(A,B)
A,B = ortho_latin(5)
@test check_ortho(A,B)
