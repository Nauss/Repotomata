using FileIO

@testset "repotomata" begin
    @testset "raw output" begin
        images = repotomata("JuliaLang/Julia")
        @test size(images, 1) == 11
        @test size(images[1]) == (123, 200)
    end

    @testset "raw output" begin
        images = repotomata("JuliaLang", "Julia", nb_epochs=5, width=100)
        @test size(images, 1) == 6
        @test size(images[1]) == (61, 100)
    end

    @testset "gif export" begin
        repotomata("JuliaLang/Julia", output=Repotomata.gif, output_path="test.gif")
        # The file exists with the correct size
        gif = load("test.gif")
        @test size(gif) == (123, 200, 11)
        # Clean up
        rm("test.gif")
    end
end
