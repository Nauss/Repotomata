# Functions and methods for image manipulation

```@meta
CurrentModule = Repotomata
```

```@docs
create_image(width::Int, height::Int, parameters::Dict)
generate_images(input::Dict)
newgeneration(image::AbstractArray{<:Colorant,2}, rule::Rule)
getpixel(image::AbstractArray{<:Colorant,2}, position::Point)
setpixel!(image::AbstractArray{<:Colorant,2}, position::Point, color::Colorant)
```
