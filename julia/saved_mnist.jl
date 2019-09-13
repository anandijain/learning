using Flux
using Statistics
using Flux: onehotbatch, onecold, crossentropy, throttle, @epochs
using BSON: @save, @load

imgs = Flux.Data.MNIST.images()
X = hcat(float.(reshape.(imgs, :))...)

labels = Flux.Data.MNIST.labels()
Y = onehotbatch(labels, 0:9)

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


# model = get_model()
# model = params_into_model("./models/myweights.bson")
model = load_model("./models/mymodel.bson")

loss(x, y) = crossentropy(model(x), y)

accuracy(x, y) = mean(onecold(model(x)) .== onecold(y))

evalcb = () -> @show(loss(X, Y))
opt = ADAM()

dataset = Iterators.repeated((X, Y), 200)

Flux.train!(loss, params(model), dataset, opt, cb=throttle(evalcb, 10))

accuracy(X, Y)

function save_weights(fn, model)
	weights = Tracker.data.(params(model))
	@save fn weights
end

function save_model(fn, model)
	@save fn model
end


save_weights("myweights.bson", model)
save_model("mymodel.bson", model)

