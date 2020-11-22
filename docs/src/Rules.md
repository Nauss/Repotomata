```@meta
CurrentModule = Repotomata
```

```@docs
Rule
Rule(neighbours::Vector{<:Point}, condition::Function)
getcolor(rule::Rule, image::AbstractArray{<:Colorant,2}, position::Point)

chromatic_rule(palette::Vector{<:Colorant}, background_color::Colorant)
game_of_life(color::Colorant, background_color::Colorant)

```
