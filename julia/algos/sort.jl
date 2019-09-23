module Sort

using Random
# hand writing classic algorithms for learning


function bubble_sort(arr)
	# garbo tier O(n^2)
	n = length(arr)

	for i in 1:n-1
		for j in 1:n-i
			if arr[j+1] <  arr[j]
				arr[j], arr[j+1] = arr[j+1], arr[j]			
			end
		end
	end
	return arr
end

function merge_sort_iter(arr)
	# iterative implementation of merge_sort
	return 0

end

function merge_sort_recur(arr)
	# recursive implementation
	n = length(arr)
	if n > 1
		mid = div(n, 2)
		left = arr[1:mid]
		right = arr[mid:end]
		
		len_left = length(left)
		len_right = length(right)

		merge_sort_recur(left)
		merge_sort_recur(right)
		i = 1
		j = 1
		k = 1
		while i < len_left && j < len_right
			if left[i] < right[j]
				arr[k] = left[i]
				i += 1
				k += 1 
			else
				arr[k] = right[j]
				j += 1
				k += 1
			end
		end
		# we take the final elements left, 
		# since the lists are already sorted,
		# we know that adding them on the end is fine
		while i < len_left
			arr[k] = left[i]
			i += 1
			k += 1
		end
		while j < len_right
			arr[k] = right[j]
			j += 1
			k += 1
		end


end

function is_sorted(arr)::Bool
	n = length(arr)
	for i in 1:n-1
		if arr[i+1] < arr[i]
			return false
		end
	end
	return true
end

###
# Tests
###
function test_bubble(n=100;v=false)
	test_arr = randperm(n)
	sorted_arr = bubble_sort(test_arr)
	if v
		println(test_arr)
		println(sorted_arr)
	end
	ret = is_sorted(sorted_arr)
	println(ret)
end


end
