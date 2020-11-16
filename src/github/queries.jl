make_language_query(pageSize, after) = begin
    if after == ""
        query = "languages(first: $pageSize) {"
    else
        query = """languages(first: $pageSize, after: "$after") {"""
    end
    
    query * """
  totalCount
  edges {
    node {
      name
      color
    }
    size
  }
  pageInfo {
    endCursor
    hasNextPage
  }
}"""
end

stargazer_count_query = "stargazerCount"

forks_count_query = """forkCount"""

watchers_count_query = """watchers {
  totalCount
}"""

updatedat_query = """updatedAt"""