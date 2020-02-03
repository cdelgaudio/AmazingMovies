import XCTest
import Combine
@testable import AmazingMovies

class FavouriteMovieTests: XCTestCase {
    
    override func setUp() {
        DataManager.shared.favourites["0"] = true
        DataManager.shared.favourites["-1"] = nil
        DataManager.shared.favourites["-2"] = true
    }
    
    override func tearDown() {
        DataManager.shared.favourites["0"] = nil
        DataManager.shared.favourites["-1"] = nil
        DataManager.shared.favourites["-2"] = nil
    }
    
    func testOldFavouriteMovie() {
        
        let movie:MoviesResponse.Movie = .init(
            popularity: nil,
            voteCount: nil,
            video: nil,
            posterPath: "/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg",
            id: 0,
            adult: nil,
            backdropPath: nil,
            originalLanguage: nil,
            originalTitle: nil,
            genreIDS: nil,
            title: nil,
            voteAverage: nil,
            overview: nil,
            releaseDate: nil
        )
        
        let viewModel = MovieViewModel(movie: movie)
        viewModel.didAppear()
        
        XCTAssert(viewModel.isFavourite, "favourites doesn't work")
    }
    
    func testNewFavouriteMovie() {
        
        let movie:MoviesResponse.Movie = .init(
            popularity: nil,
            voteCount: nil,
            video: nil,
            posterPath: "/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg",
            id: -1,
            adult: nil,
            backdropPath: nil,
            originalLanguage: nil,
            originalTitle: nil,
            genreIDS: nil,
            title: nil,
            voteAverage: nil,
            overview: nil,
            releaseDate: nil
        )
        
        let viewModel = MovieViewModel(movie: movie)
        viewModel.didAppear()
        viewModel.toggleFavourite()
        
        XCTAssert(viewModel.isFavourite, "favourites doesn't work")
    }
    
    func testRemoveFavouriteMovie() {
        let movie:MoviesResponse.Movie = .init(
            popularity: nil,
            voteCount: nil,
            video: nil,
            posterPath: "/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg",
            id: -2,
            adult: nil,
            backdropPath: nil,
            originalLanguage: nil,
            originalTitle: nil,
            genreIDS: nil,
            title: nil,
            voteAverage: nil,
            overview: nil,
            releaseDate: nil
        )
        
        let viewModel = MovieViewModel(movie: movie)
        viewModel.didAppear()
        viewModel.toggleFavourite()
        
        XCTAssert(!viewModel.isFavourite, "favourites doesn't work")
    }

}
