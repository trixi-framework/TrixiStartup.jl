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
  8.132081 seconds (14.85 M allocations: 970.145 MiB, 6.98% gc time, 8.63% compilation time: 17% of which was recompilation)

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

────────────────────────────────────────────────────────────────────────────────────────────────────
Trixi.jl simulation finished.  Final time: 0.01  Time steps: 1 (accepted), 1 (total)
────────────────────────────────────────────────────────────────────────────────────────────────────

 ────────────────────────────────────────────────────────────────────────────────────
              Trixi.jl                      Time                    Allocations
                                   ───────────────────────   ────────────────────────
         Tot / % measured:              7.16s /  99.8%            661MiB / 100.0%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 analyze solution               2    7.04s   98.5%   3.52s    661MiB  100.0%   330MiB
 I/O                            3    109ms    1.5%  36.3ms    156KiB    0.0%  52.0KiB
   ~I/O~                        3   96.3ms    1.3%  32.1ms    100KiB    0.0%  33.3KiB
   save solution                2   12.6ms    0.2%  6.28ms   51.0KiB    0.0%  25.5KiB
   get element variables        2   42.0μs    0.0%  21.0μs   5.16KiB    0.0%  2.58KiB
   save mesh                    2    220ns    0.0%   110ns     0.00B    0.0%    0.00B
 rhs!                           6   47.3μs    0.0%  7.89μs   9.33KiB    0.0%  1.55KiB
   volume integral              6   23.5μs    0.0%  3.92μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   9.05μs    0.0%  1.51μs   9.33KiB    0.0%  1.55KiB
   interface flux               6   5.30μs    0.0%   883ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   4.32μs    0.0%   720ns     0.00B    0.0%    0.00B
   surface integral             6   2.07μs    0.0%   345ns     0.00B    0.0%    0.00B
   prolong2mortars              6    980ns    0.0%   163ns     0.00B    0.0%    0.00B
   Jacobian                     6    530ns    0.0%  88.3ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    480ns    0.0%  80.0ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    430ns    0.0%  71.7ns     0.00B    0.0%    0.00B
   mortar flux                  6    390ns    0.0%  65.0ns     0.00B    0.0%    0.00B
   source terms                 6    130ns    0.0%  21.7ns     0.00B    0.0%    0.00B
   boundary flux                6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
 calculate dt                   2   1.04μs    0.0%   520ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  8.067862 seconds (12.27 M allocations: 717.319 MiB, 4.91% gc time, 99.68% compilation time: 9% of which was recompilation)
```

When running a second time, all compilation/recompilation is gone, as expected:
```julia
julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)
[ Info: You just called `trixi_include`. Julia may now compile the code, please be patient.

[...]

 ────────────────────────────────────────────────────────────────────────────────────
              Trixi.jl                      Time                    Allocations
                                   ───────────────────────   ────────────────────────
         Tot / % measured:             2.54ms /  93.2%            122KiB /  87.3%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 I/O                            3   1.94ms   82.0%   647μs   62.2KiB   58.3%  20.7KiB
   save solution                2   1.23ms   52.0%   616μs   42.1KiB   39.4%  21.0KiB
   ~I/O~                        3    701μs   29.6%   234μs   15.5KiB   14.6%  5.18KiB
   get element variables        2   8.97μs    0.4%  4.49μs   4.59KiB    4.3%  2.30KiB
   save mesh                    2   70.0ns    0.0%  35.0ns     0.00B    0.0%    0.00B
 analyze solution               2    380μs   16.1%   190μs   35.2KiB   33.0%  17.6KiB
 rhs!                           6   43.5μs    1.8%  7.25μs   9.33KiB    8.7%  1.55KiB
   volume integral              6   21.9μs    0.9%  3.65μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   10.8μs    0.5%  1.80μs   9.33KiB    8.7%  1.55KiB
   interface flux               6   4.34μs    0.2%   723ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.21μs    0.1%   535ns     0.00B    0.0%    0.00B
   surface integral             6   1.60μs    0.1%   267ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    370ns    0.0%  61.7ns     0.00B    0.0%    0.00B
   Jacobian                     6    320ns    0.0%  53.3ns     0.00B    0.0%    0.00B
   prolong2mortars              6    250ns    0.0%  41.7ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    220ns    0.0%  36.7ns     0.00B    0.0%    0.00B
   mortar flux                  6    200ns    0.0%  33.3ns     0.00B    0.0%    0.00B
   boundary flux                6    130ns    0.0%  21.7ns     0.00B    0.0%    0.00B
   source terms                 6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
 calculate dt                   2   1.46μs    0.1%   730ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  0.011306 seconds (10.91 k allocations: 1.630 MiB)
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
