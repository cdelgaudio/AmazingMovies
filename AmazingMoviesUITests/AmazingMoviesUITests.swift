import XCTest
@testable import AmazingMovies

class AmazingMoviesUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testLoadingExample() {
        let app = XCUIApplication()
        app.launch()
        
        let cellsQuery = XCUIApplication().collectionViews.cells
        
        let heartButton = cellsQuery.otherElements.firstMatch/*@START_MENU_TOKEN@*/.buttons["Heart"]/*[[".buttons[\"heart\"]",".buttons[\"Heart\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(heartButton.isHittable)
    }
}
