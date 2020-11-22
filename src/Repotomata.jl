module Repotomata
using Random, Serialization, JSON, FileIO
using ColorTypes, ImageAxes
using ImageView

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
The different rules
- `life`: the "game of life" rule.
- `languages`: the languages rule.

See also: [`repotomata`](@ref)
"""
@enum RuleType life chromatic

"""
    repotomata(owner::AbstractString, name::AbstractString; <keyword arguments>)
    repotomata(ownername::AbstractString; kwargs...)

Generates a cellular automata animation of the given GitHub repository.

!!! note
    When using the second method, the format must be: "owner/name".


# Arguments
- `epochs::Int=10`: the number of generations to compute.
- `width::Integer=500`: the output width (height will be automatically computed with the golden ratio).
- `output::OutputType=raw`: the output type.
- `output_path::String=""`: the output path when using OutputType.gif.
- `rule::RuleType=chromatic`: the rule to use.
- `seed_treshold::Real=0.58`: the threshold on the Perlin noise used as seed.
- `background_color::Colorant=black`: the background color.
"""
function repotomata(
    owner::AbstractString,
    name::AbstractString;
    epochs::Int=250,
    width::Int=500,
    output::OutputType=raw,
    output_path::String="",
    rule::RuleType=chromatic,
    seed_treshold::Real=0.58,   # Happens to be a good value for the Julia repository
    background_color::Colorant=black
    )

    # Get the repo information
    repo = Repo(owner, name, background_color)
    
    image_parameters::Dict{String,Any} = Dict(
        "epochs" => epochs,
        "width" => width,
        "ruletype" => rule,
        "seed_treshold" => seed_treshold
    )
    getparameters!(image_parameters, repo)

    images = generate_images(image_parameters)
    
    if output == viewer
        open_viewer(images);
    elseif output == gif
        save(output_path, cat(images..., dims=3), fps=25)
    else
        images;
    end
end

repotomata(ownername::AbstractString; kwargs...) = begin
    owner = split(ownername, "/")[1]
    name = split(ownername, "/")[2]
    repotomata(owner, name; kwargs...)
end

"""
    open_viewer(images)

Display the `images` in an interactive window.
"""
function open_viewer(images::Array{Array{ColorTypes.RGB{Float64},2},1})
    ImageView.closeall()

    epochs = size(images, 1)
    if epochs == 0
        return
    end

    height, width = size(images[1])
    
    result = AxisArray(reshape(cat(images..., dims=1), (height, epochs, width)))
    imshow(result, axes=(1, 3))
end

end # module
