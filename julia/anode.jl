module Anode
	using DifferentialEquations, Flux, DiffEqFlux, Plots, Distributions
	using LinearAlgebra
	using StatsBase
	function Data1D(num_points=1000, target_flip=false, noise_scale=0.1) 
		data = []
		targets = []

		if noise_scale > 0.0
			noise_samples = get_noise_samples(num_points, noise_scale)
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

	function ConcentricSphere(;dim=2, inner_range=(0., .5), outer_range=(1., 1.5), num_points_inner=1000, num_points_outer=2000)

		data = Array{Float64}(undef, (0, dim))
		targets = []
		for _ in 1:num_points_inner
			data = vcat(data, random_point_in_sphere(dim, inner_range[1], inner_range[2]))
			append!(targets, -1.0)
		end
		for _ in 1:num_points_outer
			data = vcat(data, random_point_in_sphere(dim, outer_range[1], outer_range[2]))
			append!(targets, 1.0)
		end
		return (data, targets)
	end

	function random_point_in_sphere(dim, min_radius, max_radius)
		unif = rand()
		distance = (max_radius - min_radius) * (unif ^ (1/dim)) + min_radius
		direction = randn(dim)
		unit_direction = direction / norm(direction, 2)
		return (distance * unit_direction)'
	end

	function ShiftedSines(dim, shift, num_points_upper, num_points_lower, noise_scale)
		data = []
		targets = []
	
		n = num_points_upper + num_points_lower

		if noise_scale > 0.0
			noise_samples = get_noise_samples(n, noise_scale)
		end
		
		for i in 1:(num_points_upper + num_points_lower)
			if i < num_points_upper
				label = 1
				y_shift = shift / 2 
			else
				label = -1
				y_shift = - shift / 2
			end

			x = 2 * rand() - 1
			y = sin(π * x) + noise_samples[i] + y_shift

			if dim == 1
				data = vcat(data, y)
			elseif dim == 2  
				# to fix
				data = vcat(data, hcat(x,y)) 
			else
				print("to do")
			end

			append!(targets, label)
		end
		return (data, targets) 
	end

	function LabelColors(labels)
		colors = []
		for label in labels
			if label > 0.0
				append!(colors, ["red"])
			else
				append!(colors, ["blue"])
			end
		end
		return colors
	end


	function get_noise_samples(n, σ)
		distribution = Normal(0.0, σ)
		samples = rand(distribution, n)
		return samples
	end

	function zipper(x, y)
		data = []
		for i in 1:length(y)
			input = x[i, :]
			target = y[i]
			tup = (input, target)
			push!(data, tup)
		end
	return data
	end

	function callback(test_data, n, loss)
		tot_n = length(test_data)
		test_indices = sample(1:tot_n, n, replace=false)

		sum = 0
		for index in test_indices
			sum += loss(test_data[index]...)
		end
		return Flux.data(sum / n)
	end

		
end
