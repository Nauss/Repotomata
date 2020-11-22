using Colors, FixedPointNumbers, Dates

include("../src/utilities/constants.jl")

@testset "Repo" begin
    @testset "Construction" begin
        repo = Repo("JuliaLang", "Julia", RGB{Float64}(0.0, 0.0, 0.0))
        @test repo.owner == "JuliaLang"
        @test repo.name == "Julia"
        @test size(repo.languages, 1) == 18
        @test repo.languages[1].name == "Julia"
        @test repo.languages[1].color == RGB{Float64}(0.6352941176470588, 0.4392156862745098, 0.7294117647058823)
        @test repo.languages[1].size > 10000000
        @test repo.stargazer_count > 30000
        @test repo.forks_count > 4000
        @test repo.watchers_count > 800
        @test repo.updatedat >= DateTime("2020-11-15T14:15:25Z", GITHUB_DATE)
    end

    @testset "Construction fails" begin
        @test_throws GitHubError Repo("Paul", "Poule", RGB{Float64}(0.0, 0.0, 0.0))
    end

    @testset "create_palette" begin
        repo = Repo("JuliaLang", "Julia", RGB{Float64}(0.0, 0.0, 0.0))
        palette = create_palette(repo)
        @test size(palette, 1) == PALETTE_SIZE - 2
        @test findfirst(color -> color ≈ repo.languages[1].color,  palette) !== nothing
    end
end
