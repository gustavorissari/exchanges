import XCTest
@testable import Exchanges

@MainActor
final class ExchangeListViewModelTests: XCTestCase {
  
  var sut: ExchangeListViewModel!
  var mockService: MockExchangeService!
  var mockCoordinator: MockExchangeCoordinator!
  
  override func setUp() {
    super.setUp()
    mockService = MockExchangeService()
    mockCoordinator = MockExchangeCoordinator(
      navigationController: UINavigationController(),
      service: mockService
    )
    
    sut = ExchangeListViewModel(service: mockService)
    sut.coordinator = mockCoordinator
  }
  
  override func tearDown() {
    sut = nil
    mockService = nil
    mockCoordinator = nil
    super.tearDown()
  }
  
  // MARK: - Navigation Tests
  
  func test_didSelectExchange_TriggersNavigation() async {
    // Given:
    let targetExchange = ExchangeInfoModel(id: "1", spotVolumeUsd: 5000)
    mockService.mapResultToReturn = .success([ExchangeMapModel(id: 1, isActive: 1)])
    mockService.infoResultToReturn = .success(["1": targetExchange])
    
    await sut.fetchExchangesMap()
    
    // When
    sut.didSelectExchange(at: 0)
    
    // Then
    XCTAssertTrue(mockCoordinator.isGoToDetailsCalled)
    XCTAssertEqual(mockCoordinator.capturedExchange?.id, "1")
  }
  
  // MARK: - Business Logic Tests
  
  func test_fetchExchangesMap_JoinsActiveIdsCorrectly() async {
    // Given:
    let mapData = [
      ExchangeMapModel(id: 1, isActive: 1),
      ExchangeMapModel(id: 2, isActive: 0),
      ExchangeMapModel(id: 3, isActive: 1)
    ]
    mockService.mapResultToReturn = .success(mapData)
    
    // When
    await sut.fetchExchangesMap()
    
    // Then:
    XCTAssertEqual(mockService.infoIds, "1,3")
  }
  
  func test_sorting_HighestVolumeFirst() async {
    // Given
    let lowVolume = ExchangeInfoModel(id: "1", spotVolumeUsd: 100)
    let highVolume = ExchangeInfoModel(id: "2", spotVolumeUsd: 999)
    
    mockService.mapResultToReturn = .success([
      ExchangeMapModel(id: 1, isActive: 1),
      ExchangeMapModel(id: 2, isActive: 1)
    ])
    mockService.infoResultToReturn = .success(["1": lowVolume, "2": highVolume])
    
    // When
    await sut.fetchExchangesMap()
    
    // Then
    let firstItem = sut.getExchangeInfo(at: 0)
    XCTAssertEqual(firstItem?.id, "2")
  }
}
