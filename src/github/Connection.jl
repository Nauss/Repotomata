using Diana, JSON, HTTP

export GitHubError, Connection

"""
    Error

Simple error wrapper.
"""
struct Error
    name::String
    type::String
    message::String
end

"""
    GitHubError

Any error related to the repository connection.

The error is created with either:
- A `HTTP.ExceptionRequest.StatusError`
- A failling `Diana.Result`
"""
struct GitHubError <: Exception
    errors::Vector{Error}

    function GitHubError(result::Diana.Result)
        jsondata = JSON.parse(result.Data)
        errors = Vector{Error}(undef, 0)
        if haskey(jsondata, "errors")
            for error in jsondata["errors"]
                push!(errors, Error("GitHub query error", error["type"], error["message"]))
            end
        end
        new(errors)
    end
    function GitHubError(error::HTTP.ExceptionRequest.StatusError)
        errors = fill(
            Error("GitHub query StatusError", string(error.status), string(error.response)),
            1
        )
        new(errors)
    end
end

"""
    Connection

Simple wrapper around `Diana.Client` with the current repository name and owner.
"""
struct Connection
    owner::String
    name::String
    client::Diana.Client

    function Connection(owner::AbstractString, name::AbstractString)
        client = GraphQLClient(GITHUB_URL, auth="Bearer $GITHUB_TOKEN")
        new(owner, name, client)
    end
end

"""
    query(connection::Connection, queryString)

The base function to make the queries.
It wraps the provided query in a "repository" query. It also handles connection and result errors.
"""
function query(connection::Connection, queryString::AbstractString)
    result = Diana.Result("", "")
    try
        result = connection.client.Query(
"""query A (\$owner:String!, \$name:String!){
    repository(name:\$name, owner:\$owner) {
        $queryString
    }
}""",
        vars=Dict("name" => connection.name, "owner" => connection.owner),
        operationName="A"
    )
    catch error
        throw(GitHubError(error))
    end

    jsondata = JSON.parse(result.Data)

    if result.Info.status != 200 || haskey(jsondata, "errors")
        throw(GitHubError(result))
    end
   
    return jsondata
end

Base.showerror(io::IO, error::GitHubError) = begin
    for e in error.errors
        println(io, """$(e.name)
Type: $(e.type)
Message: $(e.message)""")
    end 
end