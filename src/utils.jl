randspin()                               = [1,-1][rand(1:2)] # Generate a random spin
spingrid(n::Int)                         = [randspin() for i in 1:n, j in 1:n] # Generate a random spin array
magnetization(a::Array{Int, 2})          = mean(a) |> abs # Get magnetizations of the grid
namefunc(f::Function)                    = "$f"[1:end-1]  # Get the simplified name of a function
nspins(a::Array{Int, 2}, i::Int, j::Int) = [a[x,y] for (x,y) in neighbors(a,i,j)] # Get surrounding spins

# Flip a spin
function flip!(grid::Array{Int, 2}, cluster::BitArray{2})
    for j in 1:size(grid, 2), i in 1:size(grid, 1)
        if cluster[i, j] == true grid[i, j] *= -1 end
    end
end

# Return the sum of spins on a cluster
function clusterspin(grid::Array{Int, 2}, cluster::BitArray{2})
    spin = 0
    for j in 1:size(grid, 2), i in 1:size(grid, 1)
        if cluster[i,j] == true spin += grid[i,j] end
    end
    return spin
end

# Return an array of neighbors coordinates (each one in a tuple of the kind (x,y))
function neighbors(grid::Array{Int, 2}, i::Integer, j::Int)
    n = Array((Int,Int), 0)

    if i > 1             push!(n, (i-1, j  )) end
    if j > 1             push!(n, (i,   j-1)) end
    if i < size(grid, 1) push!(n, (i+1, j  )) end
    if j < size(grid, 2) push!(n, (i,   j+1)) end

    return n
end

# Phase diagram (magnetization by temperature) using given algorithm
function diagram(func::Function;
                 size::Integer      = 10,    # Size of the grid
                 ensembles::Integer = 50,    # Number of ensembles
                 h::Float64         = 0.0,   # External field
                 mintemp::Float64   = 0.5,   # Starting temperature
                 step::Float64      = 0.2,   # Step of temperatures
                 maxtemp::Float64   = 6.0,   # Final temperature
                 iters::Integer     = 50000, # Number of the iterations
                 plot::Bool         = true,  # Plot flag
                 verbose::Bool      = true)  # Verbose flag

    name  = namefunc(func)
    temps = Array(Float64, 0)
    mags  = Array(Float64, 0)
    for t in mintemp:step:maxtemp
        m = mean([func(spingrid(size), h=h, temp=t, iters=iters, plot=false, verbose=false)[end] for i in 1:ensembles])
        if verbose println("(T=$t) Avg. magnetization after $name: $m") end

        push!(temps, t)
        push!(mags,  m)
    end

    if plot
        PyPlot.plot(temps, mags, "o", color="blue")
        PyPlot.plot(temps, mags, "-", color="blue")
        PyPlot.title("Phase Diagram ($name for size $size and h=$h)")
        PyPlot.xlabel("Temperature")
        PyPlot.ylabel("Mean Magnetization")
        PyPlot.ylim(0,1.1)
        PyPlot.savefig("diag_$(name)_H=$h.png")
        PyPlot.close()
    end

    return temps, mags
end
