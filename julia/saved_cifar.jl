using Flux, Metalhead, Statistics
using Flux: onehotbatch, onecold, crossentropy, throttle
using Metalhead: trainimgs
using Images: channelview
using Statistics: mean
using Base.Iterators: partition
using Bson: @save, @load

function kernel_tups_vgg19()
	kernels = [(3, 3) for _ in 1:16]
end

