using Documenter, Repotomata

makedocs(
    sitename="Repotomata documentation",
    format=Documenter.HTML(prettyurls=get(ENV, "CI", nothing) == "true"),
    pages=[
        "Home" => "index.md",
        "Repotomata" => "repotomata.md",
        "Rules" => "Rules.md",
        "Connection and GitHub" => "connection.md",
        "Image functions" => "image.md"
    ]
)