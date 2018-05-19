export ortho_latin, check_ortho

"""
`A,B = ortho_latin(n)` returns a pair of orthogonal `n`-by-`n`
Latin squares.
"""
function ortho_latin(n::Int)
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
