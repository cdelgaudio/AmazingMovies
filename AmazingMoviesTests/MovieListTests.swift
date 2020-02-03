import XCTest
import Combine
@testable import AmazingMovies

class MovieListTests: XCTestCase {

    private var disposables: Set<AnyCancellable> = .init()

    func testLoadedState() {
        let expectation = self.expectation(description: "loaded")
        
        let viewModel = MovieListViewModel()
        viewModel.nextPage()
        
        viewModel.$state.sink {
            switch $0 {
            case .loaded:
                expectation.fulfill()
            default:
                break
            }
        }
        .store(in: &disposables)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    func testLoadingState() {        
        let viewModel = MovieListViewModel()
        viewModel.nextPage()
        
        switch viewModel.state {
        case .loading:
            XCTAssert(true)
        default:
            XCTAssert(false, "wrong state")
        }
    }

}
