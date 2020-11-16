using Random, Colors, GeometryBasics, LinearAlgebra
using Dates

include("utilities/perlinnoise.jl")
include("rules/game_of_life.jl")
include("rules/languages.jl")

export generate_images

function generate_images(input::Dict)
    # Get the parameters
    parameters = copy(input)
    nb_epochs = parameters["nb_epochs"]
    width = parameters["width"]
    height = floor(Int, width / MathConstants.golden)
    maincolor = parameters["color"]
    palette = parameters["palette"]
    stargazer_count = parameters["stargazerCount"]

    # Create the Rule
    # rule = game_of_life(maincolor)
    rule = languages(palette)

    # Create a black image
    image = create_image(width, height, parameters, rule)

    # Evolution
    evolution = [image]
    for g = 1:nb_epochs
        image = newgeneration(image, rule)
        push!(evolution, image)
    end

    return evolution
end

function setpixel!(image::AbstractArray{<:Colorant,2}, position::Point, color::Colorant)
    # bounds check ?
    image[position[2], position[1]] = color
end

function getpixel(image::AbstractArray{<:Colorant,2}, position::Point)::Colorant
    # bounds check ?
    image[position[2], position[1]]
end

function newgeneration(image::AbstractArray{<:Colorant,2}, rule::Rule)
    # Create a new image to apply the rules but test the current generation
    newimage = copy(image)
    
    # Pad the image for easy neighbours detection
    image_min = 1 .- rule.extent
    image_max = size(image) .+ 2 .* rule.extent
    padded = PaddedView(black, image,
        (image_min[1]:image_max[1], image_min[2]:image_max[2])
    )
    
    # Update every pixel
    Threads.@threads for x = 1:size(image, 2)
        for y = 1:size(image, 1)
            newimage[y, x] = getcolor(rule, padded, Point(x, y))
        end 
    end 
    return newimage
end

function create_image(width::Int, height::Int, parameters::Dict, rule::Rule)
    maincolor = parameters["color"]
    stargazer_count = parameters["stargazerCount"]
    forks_count = parameters["forksCount"]
    watchers_count = parameters["watchersCount"]
    udpatedat = parameters["updatedAt"]
    threshold = rule.threshold

     # Create a black image
    image = fill(black, height, width)

    # Fill with perlin noise
    # area = width * height
    stargazer_ratio = 100 * stargazer_count / MAX_STARGAZERS
    forks_ratio = 100 * forks_count / MAX_FORKS
    watchers_ratio = 100 * watchers_count / MAX_WATCHERS
    colored_count = 0
    for x = 1:width
        for y = 1:height
            noise = perlinsnoise(
                x * forks_ratio,
                y * watchers_ratio,
                stargazer_ratio
            )
            if noise > threshold
                image[y, x] =   maincolor
                colored_count += 1
            else
                image[y, x] = black
            end
        end 
    end
    # Add random points
    Random.seed!(Dates.datetime2epochms(udpatedat))
    for s = 1:colored_count
        position = Point(rand(1:width), rand(1:height))
        setpixel!(image, position, maincolor)
    end
    return image
end