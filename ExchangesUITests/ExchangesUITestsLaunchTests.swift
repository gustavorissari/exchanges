import XCTest

@MainActor
final class ExchangesUITestsLaunchTests: XCTestCase {
  
  private var app: XCUIApplication!
  
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments.append("--uitesting")
    app.launch()
  }
  
  override func tearDownWithError() throws {
    app = nil
  }
  
  func testCaptureListScreenScreenshot() throws {
    // 1. Identify a unique element on the List Screen
    let firstCell = app.cells["exchange_cell"].firstMatch
    
    // 2. Wait for the loading spinner to finish and data to appear
    XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
    
    // 3. Take a screenshot of the full List Screen
    let listScreenshot = XCTAttachment(screenshot: app.screenshot())
    listScreenshot.name = "Exchange List Screen - \(UIDevice.current.name)"
    listScreenshot.lifetime = .keepAlways
    add(listScreenshot)
  }
  
  func testCaptureDetailScreenScreenshot() throws {
    // 1. Navigate to Details
    let firstCell = app.cells["exchange_cell"].firstMatch
    
    // Wait for the list to load before attempting to tap
    XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
    firstCell.tap()
    
    // 2. Verify the Detail screen is loaded before taking the screenshot
    let nameLabel = app.staticTexts["exchange_name_label"]
    XCTAssertTrue(nameLabel.waitForExistence(timeout: 5))
    
    // 3. Take a screenshot of the Detail View
    let detailScreenshot = XCTAttachment(screenshot: app.screenshot())
    detailScreenshot.name = "Exchange Detail Screen - \(UIDevice.current.name)"
    detailScreenshot.lifetime = .keepAlways
    add(detailScreenshot)
  }
}
