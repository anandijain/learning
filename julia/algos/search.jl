module Search

include("./sort.jl")
using .Sort

function binary_search(v, x)
	lo = 0
	hi = length(v) + 1
	while hi - lo > 1
		m = (lo + hi) >>> 1
		if v[m] > x
			hi = m
		else 
			lo = m
		end
	end
	if lo == 0 || v[lo] != x
		return false
	else
		return true
	end
end

end
