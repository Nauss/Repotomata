using PaddedViews

"""
    An automata rule

The rule is applied to all the image pixel for each epoch.

# Fields
- `neighbours`: the pixels (relative positions) observered when applying the contidtion.
- `condition`: this function is called for each pixel and must return the new color.
- `extent`: the image padding needed by the neighbours.

"""
struct Rule
    neighbours::Vector{<:Point}
    condition::Function
    extent::Tuple{Int,Int}
    
    @doc """
        Rule(neighbours, condition)

    The rule constructor.
    It will automatically create the `extent`.
    """
    function Rule(neighbours::Vector{<:Point}, condition::Function)
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
        new(neighbours, condition, (extentx, extenty))
    end
end
  
"""
    getcolor(rule, image, position)

Computes the colors of the neighbours around `position`.
Calls the `rule`'s condition function and return its result.
"""
function getcolor(rule::Rule, image::AbstractArray{<:Colorant,2}, position::Point)::Colorant
    # Get the neighbour's colors
    colors = map(
        neighbour -> getpixel(image, position + neighbour),
        rule.neighbours
    )
    # Test the condition
    rule.condition(rule, getpixel(image, position), colors)
end
