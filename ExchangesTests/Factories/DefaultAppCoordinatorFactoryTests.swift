import XCTest
import UIKit
@testable import Exchanges

@MainActor
final class DefaultAppCoordinatorFactoryTests: XCTestCase {
  
  private var sut: DefaultAppCoordinatorFactory!
  private var mockService: MockExchangeService!
  private var spyNavigationController: SpyNavigationController!
  
  override func setUp() {
    super.setUp()
    sut = DefaultAppCoordinatorFactory()
    mockService = MockExchangeService()
    spyNavigationController = SpyNavigationController()
  }
  
  override func tearDown() {
    sut = nil
    mockService = nil
    spyNavigationController = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_makeExchangeCoordinator_shouldReturnExchangeCoordinatorWithCorrectDependencies() async {
    // When
    let coordinator = sut.makeExchangeCoordinator(
      navigationController: spyNavigationController,
      service: mockService
    )
    
    // Then
    guard let exchangeCoordinator = coordinator as? ExchangeCoordinator else {
      XCTFail("Deveria retornar uma instância de ExchangeCoordinator")
      return
    }
    
    await Task.yield()
    
    XCTAssertEqual(exchangeCoordinator.navigationController, spyNavigationController)
    XCTAssertTrue(exchangeCoordinator.service === mockService)
  }
}
