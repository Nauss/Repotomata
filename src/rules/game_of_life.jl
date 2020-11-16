# Game of life rule
#   current = black && 3 neighbours ≠ black > color
#   current ≠ black && 2 OR 3 neighbours ≠ black > color
#   else > black
game_of_life(color::Colorant) = Rule(
    EIGHT_NEIGHBOURS,
    (rule::Rule, current::Colorant, colors::Vector{<:Colorant}) -> begin
    # Count colored neighbours
    nb_black = count(color -> color == black, colors)
    if (current == black && nb_black == 5) ||
            (current ≠ black && (nb_black == 6 || nb_black == 5))
        color
    else
        black
    end
end,
    0.4
)

