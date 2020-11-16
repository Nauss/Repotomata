using PaddedViews

struct Rule
    neighbours::Vector{<:Point}
    condition::Function
    threshold::Float64
    # The image padding needed by the neighbours
    extent::Tuple{Int,Int}
    function Rule(neighbours::Vector{<:Point}, condition::Function, threshold::Float64)
        extentx, extenty = 0, 0
        for neighbour in neighbours
            x, y = abs(neighbour[1]), abs(neighbour[2])
            if x > extentx
                extentx = x
            end
            if y > extenty
                extenty = y
            end
        end
        new(neighbours, condition, threshold, (extentx, extenty))
    end
end

function getcolor(rule::Rule, image::AbstractArray{<:Colorant,2}, position::Point)::Colorant
    # Get the neighbour's colors
    colors = map(
        neighbour -> getpixel(image, position + neighbour),
        rule.neighbours
    )
    # Test the condition
    rule.condition(rule, getpixel(image, position), colors)
end
