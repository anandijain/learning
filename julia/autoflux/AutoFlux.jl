module AutoFlux
#=
AutoFlux is a set of tools for shaping and constructing simple models in Flux.




 =#


# export 
using Flux

include("./shape.jl")
include("./arch.jl")

using .Shape
export log_dims,
	get_layers,
	mlp
end
