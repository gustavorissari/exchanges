import XCTest
import UIKit
@testable import Exchanges

@MainActor
final class DefaultAppCoordinatorFactoryTests: XCTestCase {
  
  private var sut: DefaultAppCoordinatorFactory!
  private var mockService: MockExchangeService!
  private var navigationController: UINavigationController!
  
  override func setUp() {
    super.setUp()
    sut = DefaultAppCoordinatorFactory()
    mockService = MockExchangeService()
    navigationController = UINavigationController()
  }
  
  override func tearDown() {
    sut = nil
    mockService = nil
    navigationController = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_makeExchangeCoordinator_shouldReturnExchangeCoordinatorWithCorrectDependencies() async {
    // When
    let coordinator = sut.makeExchangeCoordinator(
      navigationController: navigationController,
      service: mockService
    )
    
    // Then
    guard let exchangeCoordinator = coordinator as? ExchangeCoordinator else {
      XCTFail("Deveria retornar uma instância de ExchangeCoordinator")
      return
    }
    
    XCTAssertEqual(exchangeCoordinator.navigationController, navigationController)
    XCTAssertTrue(exchangeCoordinator.service === mockService)
    
    await Task.yield()
  }
}
