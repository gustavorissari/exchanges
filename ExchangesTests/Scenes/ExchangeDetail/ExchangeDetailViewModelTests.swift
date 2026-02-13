import XCTest
@testable import Exchanges

@MainActor
final class ExchangeDetailViewModelTests: XCTestCase {
  
  private var sut: ExchangeDetailViewModel!
  private var mockService: MockExchangeService!
  private var mockExchangeInfoModel: ExchangeInfoModel!
  
  override func setUp() {
    super.setUp()
    mockService = MockExchangeService()
    mockExchangeInfoModel = ExchangeInfoModel.mock
  }
  
  override func tearDown() {
    sut = nil
    mockService = nil
    mockExchangeInfoModel = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_properties_MapCorrectlyFromModel() {
    sut = ExchangeDetailViewModel(exchangeInfo: mockExchangeInfoModel, service: mockService)
    
    XCTAssertEqual(sut.id, "1")
    XCTAssertEqual(sut.name, "Binance")
    XCTAssertEqual(sut.websiteUrl, "https://www.binance.com")
    XCTAssertEqual(sut.makerFee, "0.01%")
  }
  
  func test_makerFee_returnsDefaultString_WhenNil() {
    let model = ExchangeInfoModel(id: "1")
    
    sut = ExchangeDetailViewModel(exchangeInfo: model, service: mockService)
    
    XCTAssertEqual(sut.makerFee, "-")
  }
  
  func test_fetchExchangesAssets_Success_PopulatesCurrencies() async {
    // Given
    sut = ExchangeDetailViewModel(exchangeInfo: mockExchangeInfoModel, service: mockService)
    
    let expectation = expectation(description: "Currencies updated callback")
    sut.onCurrenciesUpdated = { expectation.fulfill() }
    
    // When
    await sut.fetchExchangesAssets()
    
    // Then
    XCTAssertEqual(mockService.assetsId, "1")
    XCTAssertEqual(sut.currencies.count, 1)
    XCTAssertEqual(sut.currencies.first?.name, "Coin")
    await fulfillment(of: [expectation], timeout: 1.0)
  }
  
  func test_fetchExchangesAssets_Failure_CallsOnError() async {
    // Given
    sut = ExchangeDetailViewModel(exchangeInfo: mockExchangeInfoModel, service: mockService)
    let expectedError = NSError(domain: "Test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
    mockService.assetsResultToReturn = .failure(expectedError)
    
    var capturedErrorMessage: String?
    sut.onError = { capturedErrorMessage = $0 }
    
    // When
    await sut.fetchExchangesAssets()
    
    // Then
    XCTAssertEqual(capturedErrorMessage, "Not Found")
  }
  
  @MainActor
  func test_loadingStatus_TransitionsCorrectly() async {
    // Given
    sut = ExchangeDetailViewModel(exchangeInfo: mockExchangeInfoModel, service: mockService)
    var loadingStates: [Bool] = []
    sut.onLoadingStatusChanged = { loadingStates.append($0) }
    
    // When
    await sut.fetchExchangesAssets()
    
    // Then
    XCTAssertEqual(loadingStates, [true, false])
  }
}
