using Random, Colors, GeometryBasics, LinearAlgebra
using Dates

include("utilities/perlinnoise.jl")
include("rules/game_of_life.jl")
include("rules/chromatic.jl")

export generate_images

"""
    generate_images(input)

Create the base image and runs the evolutions.
Return a `Vector` of the created images.
"""
function generate_images(input::Dict)
    # Get the parameters
    parameters = copy(input)
    ruletype = parameters["ruletype"]
    epochs = parameters["epochs"]
    width = parameters["width"]
    height = floor(Int, width / MathConstants.golden)
    maincolor = parameters["color"]
    palette = parameters["palette"]
    stargazers = parameters["stargazers"]
    background_color = parameters["background_color"]
    
    middle_index = round(Int, size(palette, 1) / 2.0)

    # Create the Rule
    if ruletype == life
        rule = game_of_life(maincolor, background_color)
    elseif ruletype == chromatic
        rule = chromatic_rule(palette, background_color)
    end

    # Create the image
    image = create_image(width, height, parameters)

    # Evolution
    evolution = [image]
    for g = 1:epochs
        image = newgeneration(image, rule, background_color)
        push!(evolution, image)
    end

    return evolution
end

"""
    setpixel!(image, position, color)

Set the `color` of the pixel at `position` in the `image`.
"""
function setpixel!(image::AbstractArray{<:Colorant,2}, position::Point, color::Colorant)
    # bounds check ?
    image[position[2], position[1]] = color
end

"""
    getpixel(image, position)

Return the `color` of the pixel at `position` in the `image`.
"""
function getpixel(image::AbstractArray{<:Colorant,2}, position::Point)::Colorant
    # bounds check ?
    image[position[2], position[1]]
end

"""
    newgeneration(image, rule)

Produce a new image by applying the `rule` to the given `image`.
"""
function newgeneration(image::AbstractArray{<:Colorant,2}, rule::Rule, background_color::Colorant)
    # Create a new image to apply the rules but test the current generation
    newimage = copy(image)
    
    # Pad the image for easy neighbours detection
    image_min = 1 .- rule.extent
    image_max = size(image) .+ 2 .* rule.extent
    padded = PaddedView(background_color, image,
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

"""
    create_image(width, height, parameters)

Create the base image with the given `width` and `height`.
The `parameters` will be used to generate the Perlin noise and the random points.
"""
function create_image(width::Int, height::Int, parameters::Dict)
    maincolor = parameters["color"]
    stargazers = parameters["stargazers"]
    forks_count = parameters["forks"]
    watchers_count = parameters["watchers"]
    udpatedat = parameters["updatedat"]
    threshold = parameters["seed_treshold"]
    background_color = parameters["background_color"]

     # Create an image with the background color
    image = fill(background_color, height, width)

    # Fill with perlin noise
    # area = width * height
    stargazer_ratio = 100 * stargazers / MAX_STARGAZERS
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
                image[y, x] = background_color
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