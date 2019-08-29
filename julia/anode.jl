using DifferentialEquations, Flux, DiffEqFlux, Plots, Distributions, LinearAlgebra

module Anode
	function Data1D(num_points, target_flip=False, noise_scale=0.1) 
		data = []
		targets = []
	
		noise = Normal(0.0, noise_scale)
		
		for _ in 1:num_points
			if rand() > 0.5
				data_point = 1.0
				target = 1.0
			else
				data_point = -1.0
				target = -1.0
			end
	
			if target_flip
				target *= -1
			end

			if noise_scale > 0.0
				data_point += noise.sample()
			end
		
			append!(data, data_point)
			append!(targets, target)
		end

		return (data, targets)
	end

	function ConcentricSphere(dim, inner_range, outer_range, num_points_inner, num_points_outer)
		data = []
		targets = []
		for _ in 1:num_points_inner
			append!(data, random_point_in_sphere(dim, inner_range[1], inner_range[2]))
			append!(targets, -1.0)
		end
		for _ in 1:num_points_outer
			append!(data, random_point_in_sphere(dim, outer_range[1], outer_range[2]))
			append!(targets, 1.0)
		end
		return (data, targets)
	end

	function random_point_in_sphere(dim, min_radius, max_radius)
		unif = rand()
		distance = (max_radius - min_radius) * (unif * (1/dim)) + min_radius
		direction = randn(dim)
		unit_direction = direction / norm(direction, 2)
		return distance * unit_direction
	end
end
