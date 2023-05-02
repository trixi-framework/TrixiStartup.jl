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
         Tot / % measured:              7.07s /  99.8%            662MiB / 100.0%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 analyze solution               2    6.95s   98.5%   3.47s    662MiB  100.0%   331MiB
 I/O                            3    108ms    1.5%  36.0ms    156KiB    0.0%  52.0KiB
   ~I/O~                        3   95.7ms    1.4%  31.9ms    100KiB    0.0%  33.3KiB
   save solution                2   12.4ms    0.2%  6.20ms   51.0KiB    0.0%  25.5KiB
   get element variables        2   39.8μs    0.0%  19.9μs   5.16KiB    0.0%  2.58KiB
   save mesh                    2    170ns    0.0%  85.0ns     0.00B    0.0%    0.00B
 rhs!                           6   47.8μs    0.0%  7.97μs   9.33KiB    0.0%  1.55KiB
   volume integral              6   24.1μs    0.0%  4.02μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   9.75μs    0.0%  1.62μs   9.33KiB    0.0%  1.55KiB
   interface flux               6   5.18μs    0.0%   863ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.94μs    0.0%   657ns     0.00B    0.0%    0.00B
   surface integral             6   1.97μs    0.0%   328ns     0.00B    0.0%    0.00B
   prolong2mortars              6    610ns    0.0%   102ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    600ns    0.0%   100ns     0.00B    0.0%    0.00B
   Jacobian                     6    500ns    0.0%  83.3ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    500ns    0.0%  83.3ns     0.00B    0.0%    0.00B
   mortar flux                  6    380ns    0.0%  63.3ns     0.00B    0.0%    0.00B
   source terms                 6    140ns    0.0%  23.3ns     0.00B    0.0%    0.00B
   boundary flux                6    130ns    0.0%  21.7ns     0.00B    0.0%    0.00B
 calculate dt                   2   1.12μs    0.0%   560ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  7.952507 seconds (12.36 M allocations: 724.299 MiB, 4.71% gc time, 99.66% compilation time: 9% of which was recompilation)
```

Interestingly, a second run will result in much faster execution time (as
expected, since some functions that were not properly precompiled have now
been run successfully), but still include compilation and recompilation time:
```julia
julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)
[ Info: You just called `trixi_include`. Julia may now compile the code, please be patient.

[...]

 ────────────────────────────────────────────────────────────────────────────────────
              Trixi.jl                      Time                    Allocations
                                   ───────────────────────   ────────────────────────
         Tot / % measured:             2.57ms /  92.6%            122KiB /  87.3%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 I/O                            3   1.93ms   81.4%   645μs   62.2KiB   58.3%  20.7KiB
   save solution                2   1.22ms   51.3%   609μs   42.1KiB   39.4%  21.0KiB
   ~I/O~                        3    706μs   29.7%   235μs   15.5KiB   14.6%  5.18KiB
   get element variables        2   9.72μs    0.4%  4.86μs   4.59KiB    4.3%  2.30KiB
   save mesh                    2   60.0ns    0.0%  30.0ns     0.00B    0.0%    0.00B
 analyze solution               2    400μs   16.8%   200μs   35.2KiB   33.0%  17.6KiB
 rhs!                           6   42.1μs    1.8%  7.01μs   9.33KiB    8.7%  1.55KiB
   volume integral              6   22.2μs    0.9%  3.70μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   9.16μs    0.4%  1.53μs   9.33KiB    8.7%  1.55KiB
   interface flux               6   4.33μs    0.2%   722ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.11μs    0.1%   518ns     0.00B    0.0%    0.00B
   surface integral             6   1.58μs    0.1%   263ns     0.00B    0.0%    0.00B
   Jacobian                     6    360ns    0.0%  60.0ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    330ns    0.0%  55.0ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    290ns    0.0%  48.3ns     0.00B    0.0%    0.00B
   prolong2mortars              6    250ns    0.0%  41.7ns     0.00B    0.0%    0.00B
   mortar flux                  6    190ns    0.0%  31.7ns     0.00B    0.0%    0.00B
   source terms                 6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
   boundary flux                6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
 calculate dt                   2    811ns    0.0%   406ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  0.104255 seconds (16.25 k allocations: 1.980 MiB, 22.71% gc time, 65.62% compilation time: 18% of which was recompilation)
```

Only when run a third time, all compilation and recompilation is gone:
```julia
julia> @time trixi_include("../precompile/tree_2d_dgsem_elixir_euler_ec.jl", tspan=(0.0, 0.01), initial_refinement_level=1, polydeg=3)
[ Info: You just called `trixi_include`. Julia may now compile the code, please be patient.

[...]

 ────────────────────────────────────────────────────────────────────────────────────
              Trixi.jl                      Time                    Allocations
                                   ───────────────────────   ────────────────────────
         Tot / % measured:             2.50ms /  93.2%            122KiB /  87.3%

 Section                   ncalls     time    %tot     avg     alloc    %tot      avg
 ────────────────────────────────────────────────────────────────────────────────────
 I/O                            3   1.90ms   81.5%   632μs   62.2KiB   58.4%  20.7KiB
   save solution                2   1.20ms   51.5%   599μs   42.1KiB   39.5%  21.0KiB
   ~I/O~                        3    687μs   29.5%   229μs   15.5KiB   14.6%  5.18KiB
   get element variables        2   10.6μs    0.5%  5.28μs   4.59KiB    4.3%  2.30KiB
   save mesh                    2   50.0ns    0.0%  25.0ns     0.00B    0.0%    0.00B
 analyze solution               2    389μs   16.7%   195μs   34.9KiB   32.8%  17.4KiB
 rhs!                           6   41.7μs    1.8%  6.95μs   9.33KiB    8.8%  1.55KiB
   volume integral              6   21.8μs    0.9%  3.64μs     0.00B    0.0%    0.00B
   ~rhs!~                       6   9.23μs    0.4%  1.54μs   9.33KiB    8.8%  1.55KiB
   interface flux               6   4.33μs    0.2%   722ns     0.00B    0.0%    0.00B
   prolong2interfaces           6   3.14μs    0.1%   523ns     0.00B    0.0%    0.00B
   surface integral             6   1.53μs    0.1%   255ns     0.00B    0.0%    0.00B
   Jacobian                     6    320ns    0.0%  53.3ns     0.00B    0.0%    0.00B
   prolong2mortars              6    290ns    0.0%  48.3ns     0.00B    0.0%    0.00B
   prolong2boundaries           6    290ns    0.0%  48.3ns     0.00B    0.0%    0.00B
   reset ∂u/∂t                  6    260ns    0.0%  43.3ns     0.00B    0.0%    0.00B
   mortar flux                  6    200ns    0.0%  33.3ns     0.00B    0.0%    0.00B
   boundary flux                6    140ns    0.0%  23.3ns     0.00B    0.0%    0.00B
   source terms                 6    120ns    0.0%  20.0ns     0.00B    0.0%    0.00B
 calculate dt                   2    810ns    0.0%   405ns     0.00B    0.0%    0.00B
 ────────────────────────────────────────────────────────────────────────────────────

  0.010666 seconds (10.85 k allocations: 1.627 MiB)
```

## Authors
TrixiStartup.jl was initiated by
[Michael Schlottke-Lakemper](https://lakemper.eu)
(RWTH Aachen University/High-Performance Computing Center Stuttgart (HLRS), Germany) and
[Hendrik Ranocha](https://ranocha.de) (University of Hamburg, Germany), who are
also its maintainers.

## License and contributing
TrixiStartup.jl is licensed under the MIT license (see [LICENSE.md](LICENSE.md)).
