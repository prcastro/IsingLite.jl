## IsingLite

Some fun with 2-dimensional [Ising model](https://en.wikipedia.org/wiki/Ising_model) and algorithms as Heat Bath, Metropolis and Wolff. This package provides function to create and play with simples simulations and Monte Carlo algorithms.

## Installation

To install this package, inside Julia REPL, type:

```julia
Pkg.clone("git://github.com/brk00/IsingLite.jl.git")
```

## Usage

This package is intended to be used from inside the Julia REPL. To load the package, after installing it, type:

```julia
using IsingLite
```

### Creating a spin grid

A `n` by `n` random grid of spins can be created by using the `spingrid` function. The grid created is a simple 2-dimensional Julia `Array`, and not a special data type. Example:

```julia
g = spingrid(10) # Create a 10x10 spin grid
```

### Running algorithms on spin grids

This package supports heatbath, matropolis and wolff algorithms for the Ising Model. To run any of these, you can use the respective function on a previously created spin grid. Example:

```julia
g = spingrid(25) #Create a spin grid

heatbath!(g)
```

The function will return an array with the values of magnetization of the grid after each iteration. Also, a plot showing the magnetization of the grid by the number of iterations will be saved on working directory.

You can add keyword arguments to the algorithms' functions:

```julia
heatbath!(g, verbose=false)
```

All functions (`heatbath!`, `metropolis!`, `wolff!`) support basically the same API. The supported keyword arguments are:

- `h`, a `Float64` number indicating the value of the external field (default is `0.0`)
- `temp`, a `Float64` number indicating the temperature of the simulation (default is `1.0`) 
- `iters`, an `Integer` indicating the number of iterations to be performed (default is `5000` in the case of `heatbath!` and `metropolis!`, and `30` in the case of `wolff!`)
- `plot`, a `Bool` indicating if the user want or not to plot the result (default is `true`)
- `verbose`, a `Bool` indicating if the user want the function to print something during or after the run (default is `true`)

### Producing Phase Diagrams

You can produce a phase diagram, by calling the `diagram` function, which returns two arrays: one of temperatures and the other of the grid's magnetization at each temperature. Example:

```julia
t, m = diagram(heatbath!)
```

The only non-optional argument of the `diagram` function is a function `f` implementing the algorithm you want. As said before, this package only provide the functions `heatbath!`, `metropolis!`, and `wolff!`, but you can pass any function with the same API of these (detailed on the previous section), and the `diagram` will produce a phase diagram accordingly. This function also support many keyword arguments:

- `size`, a `Integer` with the size of the spin grid used to generate the diagram (default is `10`)
- `ensembles`, an `Integer` denoting the number of ensembles (default is `50`)
- `h`, a `Float64` number indicating the value of the external field (default is `0.0`)
- `mintemp`, a `Float64` number indicating the temperature at which the simulation starts (default is `0.5`)
- `step`, a `Float64` number indicating by what value the temperature changes at each iteration (default is `0.2`)
- `maxtemp`, a `Float64` number indicating the temperature at which the simulation end (default is `0.5`)
- `iters`, an `Integer` indicating the number of iterations to be performed inside the given algorithm (default is `5000`)
- `plot`, a `Bool` indicating if the user want or not to plot the result (default is `true`)
- `verbose`, a `Bool` indicating if the user want the function to print something during or after the run (default is `true`)

### Auxiliary functions

The function `neighbors` receives a grid `g`, and two coordinates `i` and `j` inside it, and return an `Array` of coordinates (each one in a tuple of the kind (x,y)) of it's neighbors. Example:

```julia
g = spingrid(10)

# Get the coordinates of the neighbors of g[1,1]
neighbors(g, 1, 1) # Returns [(2,1), (1,2)]
```

The function `nspins` receives a grid `g`, and two coordinates `i` and `j` inside it, and return an `Array` of spins surrounding it.

```julia
g = spingrid(10)

# Get the spins of the neighbors of g[1,1]
nspins(g, 1, 1)
```