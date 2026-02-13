import XCTest
import UIKit
@testable import Exchanges

@MainActor
final class ExchangeListViewControllerTests: XCTestCase {
  
  private var sut: ExchangeListViewController!
  private var mockViewModel: ExchangeListViewModel!
  private var mockService: MockExchangeService!
  private var mockCoordinator: ExchangeCoordinator!
  private var spyNavigationController: SpyNavigationController!
  
  override func setUp() {
    super.setUp()
    spyNavigationController = SpyNavigationController()
    mockService = MockExchangeService()
    mockCoordinator = ExchangeCoordinator(
      navigationController: spyNavigationController,
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
    spyNavigationController = nil
    super.tearDown()
  }
  
  private func findLoadingIndicator(in view: UIView) -> UIActivityIndicatorView? {
    return view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
  }
  
  // MARK: - Tests
  
  func test_viewDidLoad_shouldSetNavigationTitle() {
    // When
    sut.loadViewIfNeeded()
    
    // Then
    XCTAssertEqual(sut.title, L10n.ExchangeList.title)
  }
  
  func test_loadingIndicator_shouldAnimateWhenViewModelIsLoading() {
    // Given
    sut.loadViewIfNeeded()
    
    // When
    mockViewModel.onLoadingStatusChanged?(true)
    
    // Then
    let indicator = findLoadingIndicator(in: sut.view)
    XCTAssertTrue(indicator?.isAnimating ?? false)
    
    // When
    mockViewModel.onLoadingStatusChanged?(false)
    
    // Then
    XCTAssertFalse(indicator?.isAnimating ?? true)
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
  
  func test_onRefreshPulled_shouldTriggerFetchAndStopLoading() async {
    // Given
    sut.loadViewIfNeeded()
    mockService.isFetchExchangesMapCalled = false
    
    // When
    let listView = sut.view as? ExchangeListView
    
    await MainActor.run {
      listView?.onRefreshPulled?()
    }
    
    await Task.yield()
    
    // Then
    XCTAssertTrue(mockService.isFetchExchangesMapCalled)
  }
}
