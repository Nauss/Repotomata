"""
    chromatic_rule(palette, background_color)

Create a "Chromatic rule" with the following condition:
```
    if current == background_color
        3 OR 4 neighbours ≠ background_color  > neighbours' color of the "smaller" in the palette
        else  > background_color
    else
        7 OR 8 neighbours ≠ background_color  > background_color
        3 OR 4 neighbours ≠ background_color  > current
        1 OR 2 neighbours ≠ background_color  > previous color in palette or reset to the middle
        5 OR 6 neighbours ≠ background_color  > next color in palette or reset to the middle
```
"""
chromatic_rule(palette::Vector{<:Colorant}, background_color::Colorant) = Rule(
    EIGHT_NEIGHBOURS,
    (rule::Rule, current::Colorant, colors::Vector{<:Colorant}) -> begin
    # Get current color index in palette
    index = findfirst(color -> color == current, palette)
    
    colored_neighbours = filter(color -> color ≠ background_color, colors)
    nb_colored_neighbours = size(colored_neighbours, 1)

    # background_color
    if index === nothing
        # Lives if 3 or 4 neighbours
        if nb_colored_neighbours == 3 || nb_colored_neighbours == 4
            sort(
                colored_neighbours,
                by=color -> findfirst(c -> c == color, palette),
                rev=true)[1]
        else
            background_color
        end
    else
        # Dies if 7 or 8 neighbours
        if nb_colored_neighbours >= 7
            background_color
        elseif nb_colored_neighbours == 3 || nb_colored_neighbours == 4 
            # Do nothing
            current
        elseif nb_colored_neighbours == 1 || nb_colored_neighbours == 2 
            if index - 1 >= 1
                # Update color "darker"
                palette[index - 1]
            else
                # Reset
                middle_index = round(Int, size(palette, 1) / 2.0)
                palette[middle_index]
            end
        else # 5, 6
            if index + 1 <= size(palette, 1)
                # Update color "lighter"
                palette[index + 1]
            else
                # Reset
                middle_index = round(Int, size(palette, 1) / 2.0)
                palette[middle_index]
            end
        end
    end
end
)