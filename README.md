# TrixiStartup.jl

**Warning: This repository is highly experimental, thus anything can change at any
time and without warning, including the existence of the repository itself.**

This is an experiment to set up a startup package for some typical
[Trixi.jl](https://github.com/trixi-framework/Trixi.jl)
workloads for Julia v1.9+, with the goal of reducing the startup time for new
users.

*Note: While this package also works with Julia v1.8, it was designed for Julia v1.9+
to make use of the pkgimages infrastructure, i.e., the ability to cache fully
compiled code.*

## Installation
Install this package locally by, e.g., cloning it and then creating a `run`
directory, where it is added as a development package:
```shell
git clone git@github.com:trixi-framework/TrixiStartup.jl.git
mkdir TrixiStartup.jl/run && cd TrixiStartup.jl/run
JULIA_DEPOT_PATH=$PWD/depot julia-1.9-rc3 --project=. -e 'using Pkg; Pkg.develop(path=".."); Pkg.precompile()'
```
Note that it is not necessary to create a local depot but it can help during
development.

## Usage
Inside the `run` directory, start Julia with the same arguments as used during installation:
```shell
JULIA_DEPOT_PATH=$PWD/depot julia-1.9-rc3 --project=.
```
Then, run one of the examples that were also used for precompilation:
```julia
julia> @time using TrixiStartup
  8.824586 seconds (15.22 M allocations: 1011.990 MiB, 6.98% gc time, 7.74% compilation time: 18% of which was recompilation)

julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)
[ Info: You just called `trixi_include`. Julia may now compile the code, please be patient.

████████╗██████╗ ██╗██╗  ██╗██╗
╚══██╔══╝██╔══██╗██║╚██╗██╔╝██║
   ██║   ██████╔╝██║ ╚███╔╝ ██║
   ██║   ██╔══██╗██║ ██╔██╗ ██║
   ██║   ██║  ██║██║██╔╝ ██╗██║
   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ SemidiscretizationHyperbolic                                                                     │

[...]

 ────────────────────────────────────────────────────────────────────────────────────
              Trixi.jl                      Time                    Allocations
                                   ───────────────────────   ────────────────────────
         Tot / % measured:              316ms /  61.2%           10.3MiB /  38.7%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 I/O                            3    104ms   53.7%  34.7ms    156KiB    3.8%  52.0KiB
   ~I/O~                        3   92.0ms   47.5%  30.7ms    100KiB    2.4%  33.3KiB
   save solution                2   11.9ms    6.2%  5.96ms   51.0KiB    1.3%  25.5KiB
   get element variables        2   40.6μs    0.0%  20.3μs   5.16KiB    0.1%  2.58KiB
   save mesh                    2    790ns    0.0%   395ns     0.00B    0.0%    0.00B
 analyze solution               2   89.5ms   46.3%  44.8ms   3.82MiB   95.9%  1.91MiB
 rhs!                           6   50.1μs    0.0%  8.34μs   9.33KiB    0.2%  1.55KiB
   volume integral              6   23.7μs    0.0%  3.95μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   11.2μs    0.0%  1.87μs   9.33KiB    0.2%  1.55KiB
   interface flux               6   5.45μs    0.0%   908ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.85μs    0.0%   642ns     0.00B    0.0%    0.00B
   surface integral             6   2.64μs    0.0%   440ns     0.00B    0.0%    0.00B
   mortar flux                  6    660ns    0.0%   110ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    590ns    0.0%  98.3ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    570ns    0.0%  95.0ns     0.00B    0.0%    0.00B
   Jacobian                     6    540ns    0.0%  90.0ns     0.00B    0.0%    0.00B
   prolong2mortars              6    520ns    0.0%  86.7ns     0.00B    0.0%    0.00B
   source terms                 6    160ns    0.0%  26.7ns     0.00B    0.0%    0.00B
   boundary flux                6    140ns    0.0%  23.3ns     0.00B    0.0%    0.00B
 calculate dt                   2   1.78μs    0.0%   890ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  2.070784 seconds (3.54 M allocations: 201.166 MiB, 4.34% gc time, 98.55% compilation time: 36% of which was recompilation)
```

When running a second time, all compilation/recompilation is gone, as expected:
```julia
julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)
[ Info: You just called `trixi_include`. Julia may now compile the code, please be patient.

[...]

 ────────────────────────────────────────────────────────────────────────────────────
              Trixi.jl                      Time                    Allocations
                                   ───────────────────────   ────────────────────────
         Tot / % measured:             2.47ms /  92.7%            122KiB /  87.3%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 I/O                            3   1.82ms   79.6%   607μs   62.2KiB   58.3%  20.7KiB
   save solution                2   1.16ms   50.7%   579μs   42.1KiB   39.4%  21.0KiB
   ~I/O~                        3    653μs   28.6%   218μs   15.5KiB   14.6%  5.18KiB
   get element variables        2   9.45μs    0.4%  4.72μs   4.59KiB    4.3%  2.30KiB
   save mesh                    2   80.0ns    0.0%  40.0ns     0.00B    0.0%    0.00B
 analyze solution               2    422μs   18.5%   211μs   35.2KiB   33.0%  17.6KiB
 rhs!                           6   42.5μs    1.9%  7.08μs   9.33KiB    8.7%  1.55KiB
   volume integral              6   22.0μs    1.0%  3.67μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   10.0μs    0.4%  1.67μs   9.33KiB    8.7%  1.55KiB
   interface flux               6   4.21μs    0.2%   702ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.12μs    0.1%   520ns     0.00B    0.0%    0.00B
   surface integral             6   1.55μs    0.1%   258ns     0.00B    0.0%    0.00B
   Jacobian                     6    350ns    0.0%  58.3ns     0.00B    0.0%    0.00B
   mortar flux                  6    260ns    0.0%  43.3ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    260ns    0.0%  43.3ns     0.00B    0.0%    0.00B
   prolong2mortars              6    240ns    0.0%  40.0ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    190ns    0.0%  31.7ns     0.00B    0.0%    0.00B
   source terms                 6    130ns    0.0%  21.7ns     0.00B    0.0%    0.00B
   boundary flux                6    130ns    0.0%  21.7ns     0.00B    0.0%    0.00B
 calculate dt                   2    980ns    0.0%   490ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  0.010797 seconds (10.82 k allocations: 1.625 MiB)
```

## Compare to regular use of OrdinaryDiffEq.jl and Trixi.jl
To compare this to a regular use of Trixi.jl, go to the `TrixiStartup.jl`
directory and use the following commands to set up the packages in a new
`run-regular` directory:
```shell
mkdir run-regular && cd run-regular
JULIA_DEPOT_PATH=$PWD/depot julia-1.9-rc3 --project=. -e 'using Pkg; Pkg.add(["OrdinaryDiffEq", "Trixi"); Pkg.precompile()'
```
Then, start Julia
```shell
JULIA_DEPOT_PATH=$PWD/depot julia-1.9-rc3 --project=.
```
and load OrdinaryDiffEq.jl and Trixi.jl the old-fashioned way, before running
the same example from above:
```julia
julia> @time using OrdinaryDiffEq, Trixi
  6.396453 seconds (11.96 M allocations: 773.764 MiB, 6.39% gc time, 10.47% compilation time: 18% of which was recompilation)

julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)

[...]

 20.262184 seconds (39.49 M allocations: 2.274 GiB, 5.83% gc time, 99.84% compilation time: <1% of which was recompilation)

julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)

[...]

  0.010459 seconds (10.73 k allocations: 1.619 MiB)
```

## Reproducibility
For reproducible testing, there is also a set of `Project.toml`/`Manifest.toml`
files for the `run` and `run-regular` directories in the [`repro/`](repro/)
directory, from which it is possible to instantiate the exact same environment
that was used for testing.

## Authors
TrixiStartup.jl was initiated by
[Michael Schlottke-Lakemper](https://lakemper.eu)
(RWTH Aachen University/High-Performance Computing Center Stuttgart (HLRS), Germany) and
[Hendrik Ranocha](https://ranocha.de) (University of Hamburg, Germany), who are
also its maintainers.

## License and contributing
TrixiStartup.jl is licensed under the MIT license (see [LICENSE.md](LICENSE.md)).
