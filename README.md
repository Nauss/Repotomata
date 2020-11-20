# Repotomata.jl

[![Build Status](https://travis-ci.com/Nauss/Repotomata.svg?branch=main)](https://travis-ci.com/Nauss/Repotomata)

Create an animated gif from a GitHub repository using cellular automata.

## Usage

```julia
images = repotomata("JuliaLang/Julia")
repotomata("JuliaLang/Julia", output=Repotomata.viewer)
repotomata("JuliaLang/Julia", output=Repotomata.gif, output_path="test.gif")
```

## Examples

### Julia

```julia
repotomata("JuliaLang/Julia", output=Repotomata.gif, output_path="julia.gif")
```

![julia.gif example](./assets/examples/julia.gif)

### IJulia

```julia
repotomata("JuliaLang/IJulia.jl", output=Repotomata.gif, output_path="ijulia.gif",
    epochs=250,
    seed_treshold=0.8,
)
```

![ijulia.gif example](./assets/examples/ijulia.gif)

### React

```julia
repotomata("facebook/react", output=Repotomata.gif, output_path="react.gif",
    epochs=350,
    seed_treshold=0.6,
)
```

![react.gif example](./assets/examples/react.gif)

### Tensorflow

```julia
repotomata("tensorflow/tensorflow", output=Repotomata.gif, output_path="tensorflow.gif",
    width=1000,
    epochs=200,
    seed_treshold=0.56,
)
```

![tensorflow.gif example](./assets/examples/tensorflow.gif)

### Django

```julia
repotomata("django/django", output=Repotomata.gif, output_path="django.gif",
    width=800,
    epochs=200,
    seed_treshold=0.56,
    background_color=RGB(0.90, 0.90, 0.90)
)
```

![django.gif example](./assets/examples/django.gif)

### FreeCodeCamp

```julia
repotomata("freeCodeCamp/freeCodeCamp", output=Repotomata.gif, output_path="freeCodeCamp.gif",
    width=800,
    epochs=200,
    seed_treshold=0.57,
    background_color=RGB(0.2, 0.75, 0.30)
)
```

![freeCodeCamp.gif example](./assets/examples/freeCodeCamp.gif)

## Rules

New rules can be easily created. See the rules directory for examples

## Environment variables

- The [GitHub GraphQL api token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) must be provided in the environment variable `GITHUB_TOKEN`
- `JULIA_NUM_THREADS` can be used to add threads and speed up computations
