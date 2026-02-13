import XCTest

@MainActor
final class ExchangesUITests: XCTestCase {
  
  private var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments.append("--uitesting")
    app.launch()
  }
  
  override func tearDownWithError() throws {
    app = nil
  }
  
  func testAppFlowFromListToDetails() throws {
    // 1. Check navigation title
    let navigationBarTitle = app.navigationBars.staticTexts["Exchanges"]
    XCTAssertTrue(navigationBarTitle.waitForExistence(timeout: 5))
    
    // 2. Select first cell
    let firstCell = app.cells["exchange_cell"].firstMatch
    XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
    firstCell.tap()
    
    // 3. Confirm Detail View
    let nameLabel = app.staticTexts["exchange_name_label"]
    XCTAssertTrue(nameLabel.waitForExistence(timeout: 5))
  }
  
  func testOpenSafariFromDetails() throws {
    // 1. Select first cell
    let firstCell = app.cells["exchange_cell"].firstMatch
    XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
    firstCell.tap()
    
    // 2. Confirm Detail View
    let descriptionLabel = app.staticTexts["exchange_description_label"]
    XCTAssertTrue(descriptionLabel.waitForExistence(timeout: 5))
    
    // 3. Select website Link
    let urlString = "https://www.binance.com"
    let finalElement = app.descendants(matching: .any).matching(
        NSPredicate(format: "label == %@ OR identifier == %@", urlString, "exchange_website_label")
    ).firstMatch
    XCTAssertTrue(finalElement.waitForExistence(timeout: 7))
    
    if !finalElement.isHittable {
      app.swipeUp()
    }
    
    if finalElement.isHittable {
      finalElement.tap()
    } else {
      finalElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }
    
    // 4. Confirm Safari View
    let safariDone = app.buttons.element(boundBy: 0)
    XCTAssertTrue(safariDone.waitForExistence(timeout: 15))
    
    safariDone.tap()
  }
}
