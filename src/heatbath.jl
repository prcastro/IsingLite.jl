# One step of the heat bath algorithm on a Ising's spin grid
function stepheatbath!(grid::Array{Int, 2};                            # Spin grid
                       h::Float64                = 0.0,                # External field
                       temp::Float64             = 1.0,                # Temperature
                       verbose::Bool             = true)               # Verbose flag

    @assert temp != 0 "ArgumentError: Temperature can't be zero"

    # Randomly generate a new position within the grid and flip it with the right probability
    x   = rand(1:size(grid, 1))
    y   = rand(1:size(grid, 2))

    # Get the probability of a up spin on (x,y) spot
    m   = nspins(grid, x, y) |> sum
    eplus  = -m - h
    probup = exp(-eplus/temp) / (exp(-eplus/temp) + exp(eplus/temp))

    # Change spin accordingly
    grid[x,y] = rand() < probup ? 1: -1

    if verbose println("Changed $x,$y vertice spin to $(grid[x,y])") end
    return grid
end

# Several steps of the heat bath algorithm on a Ising's spin grid
function heatbath!(grid::Array{Int, 2};                            # Spin grid
                   h::Float64                = 0.0,                # External field
                   temp::Float64             = 1.0,                # Temperature
                   iters::Int                = 50000,              # Number of iterations
                   ε::Float64                = 0.001,              # Tolerance for convergence
                   plot::Bool                = true,               # Plot flag
                   verbose::Bool             = true)               # Verbose flag

    @assert iters > 100 "ArgumentError: \"iters\" must be higher than 100"
    m = [stepheatbath!(grid, h=h, temp=temp, verbose=false) |> magnetization for i in 1:iters]

    if verbose println("(T=$temp) Heat bath ended with magnetization $(m[end]) after $(length(m)) iterations") end
    if plot
        PyPlot.plot(1:length(m), m, "o", color="blue")
        PyPlot.plot(1:length(m), m, "-", color="blue")
        PyPlot.title("Heat bath for T=$temp for size $size ($(length(m)) iterations and h=$h)")
        PyPlot.xlabel("Number of Iterations")
        PyPlot.ylabel("Magnetization")
        PyPlot.ylim(0,1.1) 
        PyPlot.savefig("heatbath_T=$temp.png")
        PyPlot.close()
    end

    return m
end