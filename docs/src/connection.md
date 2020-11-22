# Connection to the GitHub GraphQL api

```@meta
CurrentModule = Repotomata
```

# The structure holding all the GitHub information

```@docs
Repo
Repo(owner::AbstractString, name::AbstractString, background_color::Colorant)
```

# The connection wrapper

```@docs
Connection
```

# The language structure

```@docs
Language
```

# Utility functions

```@docs
query(connection::Connection, queryString::AbstractString)
get_languages(connection::Connection)
create_palette(repo::Repo)
getparameters!(parameters::Dict, repo::Repo)
make_language_query
```

# Error handling

```@docs
Error
GitHubError
```
