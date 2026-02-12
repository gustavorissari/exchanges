import XCTest
import SafariServices
@testable import Exchanges

final class ExchangeCoordinatorTests: XCTestCase {
  
  private var sut: ExchangeCoordinator!
  private var spyNavigationController: SpyNavigationController!
  private var mockService: MockExchangeService!
  private var mockFactory: MockExchangeFactory!
  
  override func setUp() {
    super.setUp()
    spyNavigationController = SpyNavigationController()
    mockService = MockExchangeService()
    mockFactory = MockExchangeFactory()
    
    sut = ExchangeCoordinator(
      navigationController: spyNavigationController,
      service: mockService,
      factory: mockFactory
    )
  }
  
  override func tearDown() {
    sut = nil
    spyNavigationController = nil
    mockService = nil
    mockFactory = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_start_pushesExchangeListViewController() {
    // When:
    sut.start()
    
    // Then:
    XCTAssertTrue(spyNavigationController.pushedViewController is MockViewController)
    XCTAssertEqual(spyNavigationController.pushCount, 1)
  }
  
  func test_goToDetails_pushesExchangeDetailViewController() {
    // Given:
    let dummyInfo = ExchangeInfoModel.mock
    
    // When:
    sut.goToDetails(with: dummyInfo)
    
    // Then:
    XCTAssertTrue(spyNavigationController.pushedViewController is MockViewController)
    XCTAssertEqual(spyNavigationController.pushCount, 1)
  }
  
  func test_openWebsite_presentsSafariViewController() {
    // When:
    sut.openWebsite(urlPath: "https://www.google.com")
    
    // Then:
    XCTAssertTrue(spyNavigationController.presentedVC is SFSafariViewController)
  }
  
  func test_openWebsite_withInvalidURL_doesNotPresentAnything() {
    // When:
    sut.openWebsite(urlPath: "")
    
    // Then:
    XCTAssertNil(spyNavigationController.presentedVC)
  }
}
