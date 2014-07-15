# One step of the metropolis algorithm on a Ising's spin graph
function stepmetropolis!(grid::Array{Int, 2};
                         h::Float64    = 0.0,
                         temp::Float64 = 1.0)

    # Randomly pick a position within the grid
    x   = rand(1:size(grid, 1))
    y   = rand(1:size(grid, 2))

    # Calculate the ΔE for switching the spin
    m      = nspins(grid, x, y) |> sum
    eplus  = -m - h
    ΔE     = -2eplus * grid[x,y]

    # Change spin accordingly
    if ΔE <= 0 || rand() < exp(-ΔE/temp)
        grid[x,y] *= -1
    end
end

# Several steps of the heat bath algorithm on a Ising's spin graph
function metropolis!(grid::Array{Int, 2};
                     h::Float64=0.0,
                     temp::Float64=1.0,
                     iters::Int=50000,
                     plot::Bool=true,
                     verbose::Bool=true)

    m = Array(Float64, 0)
    for i in 1:iters
        stepmetropolis!(grid, h=h, temp=temp)
        push!(m, magnetization(grid))
        # Must find a better way to decide convergence
    end

    if verbose println("(T=$temp) Metropolis ended with magnetization $(m[end]) after $(length(m)) iterations") end
    if plot
        PyPlot.plot(1:length(m), m, "o", color="blue")
        PyPlot.plot(1:length(m), m, "-", color="blue")
        PyPlot.title("Metropolis for T=$temp for size $size ($(length(m)) iterations and H=$h)")
        PyPlot.xlabel("Number of Iterations")
        PyPlot.ylabel("Magnetization")
        PyPlot.ylim(0,1.1)
        PyPlot.savefig("Plots/metropolis/metropolis_T=$temp.png")
        PyPlot.close()
    end

    return m
end