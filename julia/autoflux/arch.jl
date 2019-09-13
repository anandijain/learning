

include("./shape.jl")
using Flux
using .Shape

function mlp(input_dim=784, output_dim=10, factor=2)
    dims = Shape.log_dims(input_dim, output_dim)
    layers = Shape.get_layers(dims)
    model(x) = foldl((x, m) -> m(x), layers, init = x)
    return model
end

function conv(dim=2, flat_in::Int=784, flat_out::Int=10; classify=true)
    # todo test for inexact error
    tups = []
    try
        dim_size = flat_in ^ (1 / dim)
        delta = Int(size - flat_out)
    catch exception
        if isa(exception, InexactError)
            return
        end
        push!((dim_size, ))
    end

    while  > flat_out



function
