using Flux
using Statistics
using Flux: onehotbatch, onecold, crossentropy, throttle, @epochs
using BSON: @save, @load
using BenchmarkTools

function get_mnist()
	imgs = Flux.Data.MNIST.images()
	X = hcat(float.(reshape.(imgs, :))...)
	
	labels = Flux.Data.MNIST.labels()
	Y = onehotbatch(labels, 0:9)
	return X, Y
end
	
function get_model()
	model = Chain(Dense(784, 100, relu), Dense(100, 10), softmax)
	return model
end

function params_into_model(fn)
	model = get_model()
	@load fn weights
	Flux.loadparams!(model, weights)
	return model
end

function load_model(fn)
	@load fn model
	return model
end

accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))

function train_model(model)
	loss(x, y) = crossentropy(model(x), y)
	evalcb = () -> @show(loss(X, Y))
	opt = ADAM()
	# dataset = Iterators.repeated((X, Y), 200)
	Flux.train!(loss, params(model), dataset, opt, cb=throttle(evalcb, 10))
end

function save_weights(fn, model)
	weights = Tracker.data.(params(model))
	@save fn weights
end

function save_model(fn, model)
	@save fn model
end

function main()
	#model_path = "./models/mymodel.bson"
	#weights_path = "./models/myweights.bson"
	X, Y = get_mnist()
	model = load_model(model_path)
	# model = params_into_model("./models/myweights.bson")
	train_model(model)
	println(accuracy(X, Y))
	#save_weights(weights_path, model)
	# save_model(model_path, model)
end

main()
