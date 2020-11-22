using ColorTypes, GeometryBasics

# Constants
const PALETTE_SIZE = 100;
const MAX_STARGAZERS = 500000;
const MAX_FORKS = 300000;
const MAX_WATCHERS = 30000;
# GitHub
const GITHUB_URL = "https://api.github.com/graphql"
const GITHUB_DATE = "yyyy-mm-ddTHH:MM:SSZ"
# Image
const white = RGB(1.0, 1.0, 1.0)
const black = RGB(0.0, 0.0, 0.0)
# Relative positions
const NORTH = Point(0, -1)
const SOUTH = Point(0, 1)
const EAST = Point(1, 0)
const WEST = Point(-1, 0)
# Default neighbours
const EIGHT_NEIGHBOURS = Vector([NORTH, NORTH + EAST, SOUTH, SOUTH + WEST, EAST, EAST + SOUTH, WEST, WEST + NORTH])
