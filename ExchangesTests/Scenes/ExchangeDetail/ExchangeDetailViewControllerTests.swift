import XCTest
@testable import Exchanges

@MainActor
final class ExchangeDetailViewControllerTests: XCTestCase {
  
  var sut: ExchangeDetailViewController!
  var viewModel: ExchangeDetailViewModel!
  var mockService: MockExchangeService!
  var mockCoordinator: MockExchangeCoordinator!
  
  override func setUp() {
    super.setUp()
    mockService = MockExchangeService()
    mockCoordinator = MockExchangeCoordinator(
      navigationController: UINavigationController(),
      service: mockService
    )
    
    viewModel = ExchangeDetailViewModel(exchangeInfo: ExchangeInfoModel.mock, service: mockService)
    
    sut = ExchangeDetailViewController(viewModel: viewModel)
    sut.coordinator = mockCoordinator
    
    sut.loadViewIfNeeded()
  }
  
  override func tearDown() {
    sut = nil
    viewModel = nil
    mockService = nil
    mockCoordinator = nil
    super.tearDown()
  }
  
  func test_viewDidLoad_triggersAssetFetch() async {
    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
    XCTAssertTrue(mockService.isFetchExchangesAssetsCalled)
  }
  
  func test_loadingIndicator_animatesWhenLoading() {
    // When
    viewModel.onLoadingStatusChanged?(true)
    
    // Then
    let indicator = sut.view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
    XCTAssertEqual(indicator?.isAnimating, true)
    
    // When
    viewModel.onLoadingStatusChanged?(false)
    XCTAssertEqual(indicator?.isAnimating, false)
  }
  
  func test_websiteTap_callsCoordinator() {
    // When
    let customView = sut.view as? ExchangeDetailView
    customView?.onWebsiteTapped?()
    
    // Then
    XCTAssertTrue(mockCoordinator.didOpenWebsiteCalled)
    XCTAssertEqual(mockCoordinator.capturedUrlPath, "https://www.binance.com")
  }
}
