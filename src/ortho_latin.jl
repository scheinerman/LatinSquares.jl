export ortho_latin, check_ortho

"""
`A,B = ortho_latin(n,quick=true)` returns a pair of orthogonal `n`-by-`n`
Latin squares. If `quick` is `true`, we first try to find the pair using
basic number theory. If that fails, or if `quick` is set to `false`,
integer programming is used.

`A,B = ortho_latin(n,r,s)` builds the Latin squares `latin(n,r)`
and `latin(n,s)` and, if they are orthogonal, returns them as the
answer. (Otherwise, throws an error.) See: `find_ortho_parameters`.
"""
function ortho_latin(n::Int, quick::Bool=true)
    if quick
        try
            r,s = find_ortho_parameters(n)
            return ortho_latin(n,r,s)
        end
    end

    MOD = Model(solver=GurobiSolver())
    @variable(MOD, X[1:n,1:n,1:n], Bin)
    @variable(MOD, Y[1:n,1:n,1:n], Bin)

    # X is a latin square

    for i=1:n
        for j=1:n
            @constraint(MOD, sum(X[i,j,k] for k=1:n)==1)
        end
    end

    for i=1:n
        for k=1:n
            @constraint(MOD, sum(X[i,j,k] for j=1:n)==1)
        end
    end

    for j=1:n
        for k=1:n
            @constraint(MOD, sum(X[i,j,k] for i=1:n)==1)
        end
    end

    for j=1:n
        for k=1:n
            if j==k
                @constraint(MOD,X[1,j,k]==1)
            else
                @constraint(MOD,X[1,j,k]==0)
            end
        end
    end

    for i=1:n
        for k=1:n
            if i==k
                @constraint(MOD,X[i,1,k]==1)
            else
                @constraint(MOD,X[i,1,k]==0)
            end
        end
    end

    # same for Y

    for i=1:n
        for j=1:n
            @constraint(MOD, sum(Y[i,j,k] for k=1:n)==1)
        end
    end

    for i=1:n
        for k=1:n
            @constraint(MOD, sum(Y[i,j,k] for j=1:n)==1)
        end
    end

    for j=1:n
        for k=1:n
            @constraint(MOD, sum(Y[i,j,k] for i=1:n)==1)
        end
    end

    for j=1:n
        for k=1:n
            if j==k
                @constraint(MOD,Y[1,j,k]==1)
            else
                @constraint(MOD,Y[1,j,k]==0)
            end
        end
    end

    # orthogonality constraints

    for i=1:n
        for j=1:n
            for ii=1:n
                for jj=1:n
                    if (i,j) != (ii,jj)
                        for k=1:n
                            for kk=1:n
                                @constraint(MOD, X[i,j,k]+Y[i,j,kk]+X[ii,jj,k]+Y[ii,jj,kk]<=3)
                            end
                        end
                    end
                end
            end
        end
    end

    status = solve(MOD)

    XX = getvalue(X)
    YY = getvalue(Y)

    A = zeros(Int,n,n)
    for i=1:n
        for j=1:n
            for k=1:n
                if XX[i,j,k]>0
                    A[i,j] = k
                end
            end
        end
    end

    B = zeros(Int,n,n)
    for i=1:n
        for j=1:n
            for k=1:n
                if YY[i,j,k]>0
                    B[i,j] = k
                end
            end
        end
    end

    return A,B
end


function ortho_latin(n::Int, r::Int, s::Int)
    A = latin(n,r)
    B = latin(n,s)
    @assert check_ortho(A,B) "Parameters n=$n, r=$r, and s=$s do not generate a pair of orthogonal Latin squares"
    return A,B
end

"""
`find_ortho_parameters(n)` tries to find parameters `r` and `s`
so that `ortho_latin(n,r,s)` will succeed. Returns `(r,s)` if
successful or throws an error if not.
"""
function find_ortho_parameters(n::Int)
    for r=1:n-1
        for s=1:n-1
            if gcd(n,r)==1 && gcd(n,s)==1 && gcd(n,r-s)==1
                return r,s
            end
        end
    end
    error("No parameters for n=$n found")
end


"""
`check_ortho(A,B)` checks that matrices `A` and `B` are a pair of
orthogonal Latin squares.
"""
function check_ortho(A::Matrix{Int},B::Matrix{Int})::Bool
    if size(A) != size(B)
        return false
    end
    if !check_latin(A) || !check_latin(B)
        return false
    end
    n,r = size(A)

    vals = unique((n+1)*A + B)
    return length(vals) == n*n
end
