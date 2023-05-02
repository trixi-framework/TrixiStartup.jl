module TrixiStartup

using PrecompileTools: @compile_workload
using Reexport: @reexport

@reexport using OrdinaryDiffEq
@reexport using Trixi

@compile_workload begin
  # Compressible Euler, P4estMesh, 2D, polydeg=3
  include(joinpath("..", "precompile", "p4est_2d_dgsem_elixir_euler_shockcapturing_ec_polydeg3.jl"))

  # Compressible Euler, P4estMesh, 2D, polydeg=4
  include(joinpath("..", "precompile", "p4est_2d_dgsem_elixir_euler_shockcapturing_ec_polydeg4.jl"))

  # Compressible Euler, P4estMesh, 3D, polydeg=3
  include(joinpath("..", "precompile", "p4est_3d_dgsem_elixir_euler_source_terms_nonperiodic_polydeg3.jl"))

  # Compressible Euler, P4estMesh, 3D, polydeg=4
  include(joinpath("..", "precompile", "p4est_3d_dgsem_elixir_euler_source_terms_nonperiodic_polydeg4.jl"))

  # Compressible Euler, TreeMesh, 2D, polydeg=3
  include(joinpath("..", "precompile", "tree_2d_dgsem_elixir_euler_ec_polydeg3.jl"))

  # Compressible Euler, TreeMesh, 2D, polydeg=4
  include(joinpath("..", "precompile", "tree_2d_dgsem_elixir_euler_ec_polydeg4.jl"))

  # Compressible Euler, TreeMesh, 3D, polydeg=3
  include(joinpath("..", "precompile", "tree_3d_dgsem_elixir_euler_ec_polydeg3.jl"))

  # Compressible Euler, TreeMesh, 3D, polydeg=4
  include(joinpath("..", "precompile", "tree_3d_dgsem_elixir_euler_ec_polydeg4.jl"))
end

end
