using Documenter, Repotomata

makedocs(
    sitename="Repotomata documentation",
    format=Documenter.HTML(prettyurls=get(ENV, "CI", nothing) == "true")
)