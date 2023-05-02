module TrixiStartup

using PrecompileTools: @compile_workload
using Reexport: @reexport
using MethodAnalysis

@reexport using OrdinaryDiffEq
@reexport using Trixi

@compile_workload begin
  # Compressible Euler, P4estMesh, 2D, polydeg=3
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "p4est_2d_dgsem_elixir_euler_shockcapturing_ec.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=0,
                polydeg=3,
               )

  # Compressible Euler, P4estMesh, 2D, polydeg=4
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "p4est_2d_dgsem_elixir_euler_shockcapturing_ec.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=0,
                polydeg=4,
               )

  # Compressible Euler, P4estMesh, 3D, polydeg=3
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "p4est_3d_dgsem_elixir_euler_source_terms_nonperiodic.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=0,
                polydeg=3,
               )

  # Compressible Euler, P4estMesh, 3D, polydeg=4
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "p4est_3d_dgsem_elixir_euler_source_terms_nonperiodic.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=0,
                polydeg=4,
               )

  # Compressible Euler, TreeMesh, 2D, polydeg=3
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "tree_2d_dgsem_elixir_euler_ec.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=1,
                polydeg=3,
               )

  # Compressible Euler, TreeMesh, 2D, polydeg=4
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "tree_2d_dgsem_elixir_euler_ec.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=1,
                polydeg=4,
               )

  # Compressible Euler, TreeMesh, 3D, polydeg=3
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "tree_3d_dgsem_elixir_euler_ec.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=1,
                polydeg=3,
               )

  # Compressible Euler, TreeMesh, 3D, polydeg=4
  trixi_include(@__MODULE__,
                joinpath("..", "precompile", "tree_3d_dgsem_elixir_euler_ec.jl"),
                tspan=(0.0, 0.01),
                initial_refinement_level=1,
                polydeg=4,
               )
end

for mi in methodinstances()
    mi.def.name === :rhs! || continue
    try
        precompile(mi.specTypes)
    catch e
        @warn "Precompilation failed for $mi with $(e)"
    end
end

end
