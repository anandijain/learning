module Anode
	using DifferentialEquations, Flux, DiffEqFlux, Plots, Distributions
	using LinearAlgebra
	function Data1D(num_points=1000, target_flip=false, noise_scale=0.1) 
		data = []
		targets = []
		if noise_scale > 0.0
			noise = Normal(0.0, noise_scale)
			noise_samples = rand(noise, num_points)
		end

		for i in 1:num_points
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
				data_point += noise_samples[i]
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

#	function ShiftedSines(dim, shift, num_points_upper, num_points_lower, noise_scale)
#		data = []
#		targets = []
#		
#		noise = Normal(0.0, noise_scale)
#		
#		for i in 1:(num_points_upper + num_points_lower)
#			if i < num_points_upper
#				label = 1
#				y_shift = shift / 2 
#			else
#				label = -1
#				y_shift = - shift / 2
#			end
#
#			x = 2 * rand() - 1
#			y = sin(π * x) + 
#
#
	function get_noise_samples(n, σ)
		distribution = Normal(0.0, σ)
		samples = rand(distribution, n)
		return samples
	end


end
