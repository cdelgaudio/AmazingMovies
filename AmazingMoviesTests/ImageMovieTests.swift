import XCTest
import Combine
@testable import AmazingMovies

class ImageMovieTests: XCTestCase {
    
    private var disposables: Set<AnyCancellable> = .init()

    func testInitEmptyMovie() {
        let viewModel = MovieViewModel(movie: .init(
            popularity: nil,
            voteCount: nil,
            video: nil,
            posterPath: nil,
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
        )
        viewModel.didAppear()
        
        switch viewModel.state {
        case .failed:
            XCTAssert(true)
        default:
            XCTAssert(false, "Wrong State: \(viewModel.state)")
        }
    }
    
    func testInitMovieWithImage() {
        let viewModel = MovieViewModel(movie: .init(
            popularity: nil,
            voteCount: nil,
            video: nil,
            posterPath: "loadingImage",
            id: 1,
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
        )
        viewModel.didAppear()
        
        switch viewModel.state {
        case .loading:
            XCTAssert(true)
        default:
            XCTAssert(false, "Wrong State: \(viewModel.state)")
        }
    }
    
    func testInitMovieWithImageAndDownload() {
        let expectation = self.expectation(description: "Downloaded")
        let viewModel = MovieViewModel(movie: .init(
            popularity: nil,
            voteCount: nil,
            video: nil,
            posterPath: "/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg",
            id: 1,
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
        )
        viewModel.didAppear()
        
        viewModel.$state.sink(receiveValue: {
            switch $0 {
            case .loaded:
                expectation.fulfill()
            default:
                break
            }
        })
        .store(in: &disposables)
        
        waitForExpectations(timeout: 2, handler: nil)

    }
}
