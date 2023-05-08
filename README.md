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
  8.821137 seconds (15.27 M allocations: 1015.745 MiB, 6.92% gc time, 7.75% compilation time: 18% of which was recompilation)

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
         Tot / % measured:              213ms /  91.2%           4.31MiB /  92.3%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 I/O                            3    105ms   53.9%  34.9ms    156KiB    3.8%  52.0KiB
   ~I/O~                        3   92.9ms   47.7%  31.0ms    100KiB    2.4%  33.3KiB
   save solution                2   11.9ms    6.1%  5.93ms   51.0KiB    1.3%  25.5KiB
   get element variables        2   38.6μs    0.0%  19.3μs   5.16KiB    0.1%  2.58KiB
   save mesh                    2    170ns    0.0%  85.0ns     0.00B    0.0%    0.00B
 analyze solution               2   89.7ms   46.1%  44.8ms   3.82MiB   95.9%  1.91MiB
 rhs!                           6   48.8μs    0.0%  8.13μs   9.33KiB    0.2%  1.55KiB
   volume integral              6   24.0μs    0.0%  4.01μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   9.34μs    0.0%  1.56μs   9.33KiB    0.2%  1.55KiB
   interface flux               6   5.38μs    0.0%   897ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.61μs    0.0%   602ns     0.00B    0.0%    0.00B
   surface integral             6   2.32μs    0.0%   387ns     0.00B    0.0%    0.00B
   prolong2mortars              6   1.33μs    0.0%   222ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    930ns    0.0%   155ns     0.00B    0.0%    0.00B
   Jacobian                     6    610ns    0.0%   102ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    570ns    0.0%  95.0ns     0.00B    0.0%    0.00B
   mortar flux                  6    400ns    0.0%  66.7ns     0.00B    0.0%    0.00B
   source terms                 6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
   boundary flux                6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
 calculate dt                   2   1.99μs    0.0%   995ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  1.189330 seconds (1.12 M allocations: 76.805 MiB, 2.94% gc time, 97.74% compilation time: 59% of which was recompilation)
```

When running a second time, all compilation/recompilation is gone, as expected:
```julia
julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)
[ Info: You just called `trixi_include`. Julia may now compile the code, please be patient.

[...]

 ────────────────────────────────────────────────────────────────────────────────────
              Trixi.jl                      Time                    Allocations
                                   ───────────────────────   ────────────────────────
         Tot / % measured:             2.37ms /  92.8%            122KiB /  87.5%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 I/O                            3   1.75ms   79.4%   582μs   62.2KiB   58.3%  20.7KiB
   save solution                2   1.10ms   49.9%   549μs   42.1KiB   39.4%  21.0KiB
   ~I/O~                        3    639μs   29.0%   213μs   15.5KiB   14.6%  5.18KiB
   get element variables        2   9.03μs    0.4%  4.51μs   4.59KiB    4.3%  2.30KiB
   save mesh                    2   70.0ns    0.0%  35.0ns     0.00B    0.0%    0.00B
 analyze solution               2    411μs   18.7%   205μs   35.2KiB   33.0%  17.6KiB
 rhs!                           6   41.9μs    1.9%  6.99μs   9.33KiB    8.7%  1.55KiB
   volume integral              6   22.5μs    1.0%  3.76μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   8.80μs    0.4%  1.47μs   9.33KiB    8.7%  1.55KiB
   interface flux               6   4.32μs    0.2%   720ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.14μs    0.1%   524ns     0.00B    0.0%    0.00B
   surface integral             6   1.64μs    0.1%   273ns     0.00B    0.0%    0.00B
   Jacobian                     6    340ns    0.0%  56.7ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    270ns    0.0%  45.0ns     0.00B    0.0%    0.00B
   prolong2mortars              6    220ns    0.0%  36.7ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    210ns    0.0%  35.0ns     0.00B    0.0%    0.00B
   mortar flux                  6    190ns    0.0%  31.7ns     0.00B    0.0%    0.00B
   source terms                 6    130ns    0.0%  21.7ns     0.00B    0.0%    0.00B
   boundary flux                6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
 calculate dt                   2    850ns    0.0%   425ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  0.010679 seconds (10.95 k allocations: 1.632 MiB)
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
