import XCTest
import UIKit
@testable import Exchanges

final class AppCoordinatorTests: XCTestCase {
  
  private var sut: AppCoordinator!
  private var mockService: MockExchangeService!
  private var mockFactory: MockAppCoordinatorFactory!
  private var spyNavigationController: SpyNavigationController!
  
  override func setUp() {
    super.setUp()
    spyNavigationController = SpyNavigationController()
    mockService = MockExchangeService()
    mockFactory = MockAppCoordinatorFactory()
    
    sut = AppCoordinator(
      navigationController: spyNavigationController,
      service: mockService,
      factory: mockFactory
    )
  }
  
  override func tearDown() {
    sut = nil
    mockService = nil
    mockFactory = nil
    spyNavigationController = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_start_createsAndStartsChildCoordinator() {
    // When:
    sut.start()
    
    // Then:
    XCTAssertEqual(sut.childCoordinators.count, 1)
    let child = mockFactory.lastCreatedCoordinator as? MockChildCoordinator
    XCTAssertNotNil(child)
    XCTAssertTrue(child?.startCalled == true)
  }
  
  func test_didFinish_removesChildCoordinatorFromStack() {
    // Given:
    sut.start()
    guard let child = sut.childCoordinators.first else {
      XCTFail("Setup failed: Child coordinator was not added to the stack.")
      return
    }
    
    // When:
    sut.didFinish(child)
    
    // Then:
    XCTAssertTrue(sut.childCoordinators.isEmpty)
  }
  
  func test_didFinish_doesNotRemoveDifferentCoordinatorInstance() {
    // Given:
    sut.start()
    let unrelatedCoordinator = MockChildCoordinator(navigationController: spyNavigationController)
    
    // When:
    sut.didFinish(unrelatedCoordinator)
    
    // Then:
    XCTAssertEqual(sut.childCoordinators.count, 1)
  }
}
