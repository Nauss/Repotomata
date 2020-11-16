using Base, Colors, Diana, JSON, Dates

include("queries.jl")
include("Connection.jl")

export Repo, Language, create_palette

struct Language
    name::String
    color::Colorant
    size::Int

    # Constructor
    function Language(name::String, color::String, size::Int) 
        new(name, parse(RGB, color), size)
    end
    Language(name::String, color::Nothing, size::Int) = Language(name, "#000000", size) 
end


struct Repo
    owner::String
    name::String
    languages::Vector{Language}
    stargazer_count::UInt
    forks_count::UInt
    watchers_count::UInt
    updatedat::DateTime

    # Constructor
    function Repo(owner::AbstractString, name::AbstractString) 
        connection = Connection(owner, name)

        # Query information
        result = query(connection, """
        $stargazer_count_query
        $forks_count_query
        $watchers_count_query
        $updatedat_query
        """)

        data = result["data"]
        repository = data["repository"]
        stargazer_count = repository["stargazerCount"]
        forks_count = repository["forkCount"]
        watchers_count = repository["watchers"]["totalCount"]
        updatedat = DateTime(repository["updatedAt"], GITHUB_DATE)
        languages = get_languages(connection)

        new(owner,
        name,
        languages,
        stargazer_count,
        forks_count,
        watchers_count,
        updatedat)
    end
end

Base.show(io::IO, repo::Repo) = print(io, """$(repo.owner)/$(repo.name)
Languages: $(size(repo.languages, 1))
Stars: $(repo.stargazer_count)
Forks: $(repo.forks_count)
Watchers: $(repo.watchers_count)
""")

function getparameters!(parameters::Dict, repo::Repo)
    parameters["color"] = repo.languages[1].color
    parameters["stargazerCount"] = repo.stargazer_count
    parameters["forksCount"] = repo.forks_count
    parameters["updatedAt"] = repo.updatedat
    parameters["watchersCount"] = repo.watchers_count
    parameters["palette"] = create_palette(repo)
end

function get_languages(connection::Connection)
    result::Vector{Language} = Vector(undef, 0)

    pagesize = 2
    has_next_page = true
    after = ""

    while has_next_page
        language_query = make_language_query(pagesize, after)
        query_result = query(connection, """
            $language_query
        """)

        data = query_result["data"]
        repository = data["repository"]
        languages = repository["languages"]

        for language in languages["edges"]
            push!(result, Language(
                language["node"]["name"],
                language["node"]["color"],
                language["size"]))
        end
    
        has_next_page = languages["pageInfo"]["hasNextPage"]
        after = languages["pageInfo"]["endCursor"]
    end

    sort!(result, by=language -> language.size, rev=true)

    return result
end

function create_palette(repo::Repo)
    palette_size = PALETTE_SIZE
    palette = Vector(undef, 0)
    coeff_l, coeff_a, coeff_b = 50, 5, 5
    
    total_size = sum(language -> language.size, repo.languages)
    for language in repo.languages
        nbcolors = ceil(Int, language.size * palette_size / total_size)
        half_colors_index = round(Int, nbcolors / 2)
        labcolor = convert(Lab, language.color)
        colors_before = Vector(undef, half_colors_index)
        colors_after = Vector(undef, half_colors_index)
        for i = 1:half_colors_index
            a = (half_colors_index - i) / half_colors_index
            b = i / half_colors_index
            colors_before[i] = convert(RGB, Lab(
                labcolor.l - coeff_l * a,
                labcolor.a - coeff_a * a,
                labcolor.b - coeff_b * a
            ))
            colors_after[i] = convert(RGB, Lab(
                labcolor.l + coeff_l * b,
                labcolor.a + coeff_a * b,
                labcolor.b + coeff_b * b
            ))
        end
        if size(palette, 1) == 0
            palette = [colors_before..., language.color, colors_after...]
        else
            palette = [colors_before..., palette..., colors_after...]
        end
    end
   
    return palette
end
