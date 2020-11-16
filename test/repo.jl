using Colors, FixedPointNumbers, Dates

include("../src/utilities/constants.jl")

@testset "Repo" begin
    @testset "Construction" begin
        repo = Repo("JuliaLang", "Julia")
        @test repo.owner == "JuliaLang"
        @test repo.name == "Julia"
        @test size(repo.languages, 1) == 18
        @test repo.languages[1].name == "Julia"
        @test repo.languages[1].color == RGB{N0f8}(0.635, 0.439, 0.729)
        @test repo.languages[1].size > 10000000
        @test repo.stargazer_count > 30000
        @test repo.forks_count > 4000
        @test repo.watchers_count > 800
        @test repo.updatedat >= DateTime("2020-11-15T14:15:25Z", GITHUB_DATE)
    end

    @testset "Construction fails" begin
        @test_throws GitHubError Repo("Paul", "Poule")
    end

    @testset "create_palette" begin
        repo = Repo("JuliaLang", "Julia")
        palette = create_palette(repo)
        @test size(palette, 1) == PALETTE_SIZE - 1
        @test findfirst(color -> color ≈ repo.languages[1].color,  palette) !== nothing
    end
end
