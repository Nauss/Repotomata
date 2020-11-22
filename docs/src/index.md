# Repotomata.jl Documentation

```@meta
CurrentModule = Repotomata
```

Generate cellular automata animations based on any GitHub repository.

## Usage

```julia
repotomata("JuliaLang/Julia")
repotomata("JuliaLang", "Julia")
```

More on the [`repotomata`](@ref) page

## How ?

When given a valid repository owner and name the repotomata function will proceed the following steps:

- Connect to the repository,
- Query the following information:
  - The languages with their colors and sizes,
  - The number of stargazers, watchers, forks and the last update time.
- Create a color palette including color variants of the languages colors. The number of colors in the palette is proportional to the size of each language
- Generate an image filled with Perlin noise generated using the stargazers, watchers and forks numbers and the given threshold,
- For each non-background pixels in the previous image we add a random pixel. The last update time is used as the Random seed,
- Evolve this image by applying the rule for each epochs

## Example

The Julia repository

```julia
repotomata("JuliaLang/Julia", output=Repotomata.gif, output_path="julia.gif")
```

![julia.gif example](../../assets/examples/julia.gif)
