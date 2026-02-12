import XCTest
import UIKit
@testable import Exchanges

@MainActor
final class ExchangeFactoryTests: XCTestCase {
  
  private var sut: DefaultExchangeFactory!
  private var mockService: MockExchangeService!
  private var mockNavigationController: UINavigationController!
  private var mockCoordinator: ExchangeCoordinator!
  
  override func setUp() {
    super.setUp()
    sut = DefaultExchangeFactory()
    mockService = MockExchangeService()
    mockNavigationController = UINavigationController()
    
    mockCoordinator = ExchangeCoordinator(
      navigationController: mockNavigationController,
      service: mockService
    )
  }
  
  override func tearDown() {
    sut = nil
    mockService = nil
    mockNavigationController = nil
    mockCoordinator = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_makeExchangeList_shouldReturnExchangeListViewControllerWithDependencies() async {
    // When
    let viewController = sut.makeExchangeList(service: mockService, coordinator: mockCoordinator)
    _ = viewController.view
    
    // Then
    guard let listVC = viewController as? ExchangeListViewController else {
      XCTFail("Factory should return an instance of ExchangeListViewController")
      return
    }
    
    await Task.yield()
    
    XCTAssertNotNil(listVC.viewModel)
    XCTAssertTrue(listVC.viewModel.coordinator === mockCoordinator)
  }
  
  func test_makeExchangeDetail_shouldReturnExchangeDetailViewController() async {
    // Given
    let expectedInfo = ExchangeInfoModel.mock
    
    // When
    let viewController = sut.makeExchangeDetail(
      exchangeInfo: expectedInfo,
      service: mockService,
      coordinator: mockCoordinator
    )
    _ = viewController.view
    
    // Then
    guard let detailVC = viewController as? ExchangeDetailViewController else {
      XCTFail("Factory should return an instance of ExchangeDetailViewController")
      return
    }
    
    await Task.yield()
    
    XCTAssertTrue(detailVC.coordinator === mockCoordinator)
  }
}
