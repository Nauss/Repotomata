using Diana, JSON, HTTP

export GitHubError, Connection

struct Error
    name::String
    type::String
    message::String
end

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

struct Connection
    owner::String
    name::String
    client::Diana.Client

    function Connection(owner::AbstractString, name::AbstractString)
        client = GraphQLClient(GITHUB_URL, auth="Bearer $GITHUB_TOKEN")
        new(owner, name, client)
    end
end

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