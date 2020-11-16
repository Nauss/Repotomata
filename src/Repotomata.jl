module Repotomata
using Random, Serialization, JSON, FileIO
using ColorTypes, ImageView, ImageAxes

include("utilities/constants.jl")
include("Rule.jl")
include("github/Repo.jl")
include("image.jl")

export repotomata, OutputType, open_viewer

"""
The different output types
- `raw`: will return a Vector of the created images.
- `viewer`: will open the result in a viewer.
- `gif`: will create a gif file at the given `output_path`.

See also: [`repotomata`](@ref)
"""
@enum OutputType raw viewer gif

"""
    repotomata(owner::AbstractString, name::AbstractString; <keyword arguments>)

Generates a cellular automata animation of the given GitHub repository.

# Arguments
- `nb_epochs::Int=10`: the number of generations to compute.
- `width::Integer=200`: the output width (height will be automatically computed with the golden ratio).
- `output::OutputType=raw`: the output type.
- `output_path::String=""`: the output path when using OutputType.gif.
"""
function repotomata(
    owner::AbstractString,
    name::AbstractString;
    nb_epochs::Int=10,
    width::Int=200,
    output::OutputType=raw,
    output_path::String=""
    )

    # Get the repo information
    repo = Repo(owner, name)
    
    image_parameters::Dict{String,Any} = Dict(
        "nb_epochs" => nb_epochs,
        "width" => width
    )
    getparameters!(image_parameters, repo)

    images = generate_images(image_parameters)
    
    if output == viewer
        open_viewer(images)
    elseif output == gif
        save(output_path, cat(images..., dims=3), fps=25)
    else
        images
    end
end

repotomata(ownername::AbstractString; kwargs...) = begin
    owner = split(ownername, "/")[1]
    name = split(ownername, "/")[2]
    repotomata(owner, name; kwargs...)
end

function open_viewer(images::Array{Array{ColorTypes.RGB{Float64},2},1})
    ImageView.closeall()

    nb_epochs = size(images, 1)
    if nb_epochs == 0
        return
    end

    height, width = size(images[1])
    
    result = AxisArray(reshape(cat(images..., dims=1), (height, nb_epochs, width)))
    imshow(result, axes=(1, 3))
end

end # module
