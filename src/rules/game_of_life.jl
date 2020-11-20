"""
    game_of_life(color, background_color)

Create a "Game of life rule" with the following condition:
```
      if current = background_color && 3 neighbours ≠ background_color > color
      if current ≠ background_color && 2 OR 3 neighbours ≠ background_color > color
      else > background_color
```
"""
game_of_life(color::Colorant, background_color::Colorant) = Rule(
    EIGHT_NEIGHBOURS,
    (rule::Rule, current::Colorant, colors::Vector{<:Colorant}) -> begin
    # Count colored neighbours
    nb_black = count(color -> color == background_color, colors)
    if (current == background_color && nb_black == 5) ||
            (current ≠ background_color && (nb_black == 6 || nb_black == 5))
        color
    else
        background_color
    end
end
)

