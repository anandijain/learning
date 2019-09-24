module Search

include("./sort.jl")
using .Sort

function binary_search_iterative(arr::AbstractVector, val; v=false)
	# assuming sorted increasingly
	n = length(arr)
	lo = 1
	hi = n
	middle = (lo+hi) >>> 1 # or div(n, 2)
	if !Sort.is_sorted(arr)
		println("input array was not sorted")
		return false
	end
	num_steps = 0

	while n > 1
		middle = (lo+hi) >>> 1 # or div(n, 2)
		mid = arr[middle]
		if val == mid
			println(string("num_steps: ", num_steps))
			return true
		elseif val < mid
			hi = middle - 1
		else 
			lo = middle + 1
		end
		# arr = arr[lo:hi]
		n = length(arr[lo:hi])
		if v
			println(string("arr_len: ", n))
			println(string("hi: ", hi))
			println(string("middle: ", middle))
			println(string("lo: ", lo))
		end
		num_steps += 1
	end
	println(string(arr, val))
	if val == arr[middle]
		return true
	else
		return false
	end

end

function binary_search_recursive(arr::AbstractVector, val)
	n = length(arr)
	if n == 1
		return arr[n] == val
	end
	lo = 0
	hi = n + 1
	m = (lo+hi) >>> 1
	if arr[m] > val
		hi = m 
	else 
		lo = m
	end
	binary_search_recursive(arr[lo + 1:hi - 1], val)
end

end
