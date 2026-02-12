import XCTest
import UIKit
@testable import Exchanges

@MainActor
final class ExchangeListViewControllerTests: XCTestCase {
  
  private var sut: ExchangeListViewController!
  private var mockViewModel: ExchangeListViewModel!
  private var mockService: MockExchangeService!
  private var mockCoordinator: ExchangeCoordinator!
  
  override func setUp() {
    super.setUp()
    mockService = MockExchangeService()
    mockCoordinator = ExchangeCoordinator(
      navigationController: UINavigationController(),
      service: mockService
    )
    
    mockViewModel = ExchangeListViewModel(service: mockService)
    mockViewModel.coordinator = mockCoordinator
    
    sut = ExchangeListViewController(viewModel: mockViewModel)
  }
  
  override func tearDown() {
    sut = nil
    mockViewModel = nil
    mockService = nil
    mockCoordinator = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_viewDidLoad_shouldSetNavigationTitle() {
    // When
    sut.loadViewIfNeeded()
    
    // Then
    XCTAssertEqual(sut.title, L10n.ExchangeList.title)
  }
  
  func test_loadingIndicator_shouldAnimateWhenViewModelIsLoading() async {
    // When
    sut.loadViewIfNeeded()
    mockViewModel.onLoadingStatusChanged?(true)
    
    // Then
    let indicator = findLoadingIndicator(in: sut.view)
    XCTAssertTrue(indicator?.isAnimating ?? false)
    
    await Task.yield()
  }
  
  private func findLoadingIndicator(in view: UIView) -> UIActivityIndicatorView? {
    return view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
  }
  
  func test_viewDidLoad_whenServiceFails_shouldShowErrorAlert() async {
    // Given
    let expectedError = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
    mockService.mapResultToReturn = .failure(expectedError)
    
    // When
    sut.loadViewIfNeeded()
    
    await Task.yield()
    
    // Then
    XCTAssertTrue(mockService.isFetchExchangesMapCalled)
  }
}
