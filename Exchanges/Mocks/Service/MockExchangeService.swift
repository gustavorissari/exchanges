// @testable import Exchanges

final class MockExchangeService: ExchangeServiceProtocol {
  
  var mapResultToReturn: Result<[ExchangeMapModel], Error> = .success(
    [ExchangeMapModel.mock]
  )
  var isFetchExchangesMapCalled = false
  
  func fetchExchangesMap() async throws -> [ExchangeMapModel] {
    isFetchExchangesMapCalled = true
    
    switch mapResultToReturn {
    case .success(let models):
      return models
    case .failure(let error):
      throw error
    }
  }
  
  var infoResultToReturn: Result<[String: ExchangeInfoModel]?, Error> = .success(
    ["1": ExchangeInfoModel.mock]
  )
  var isFetchExchangesInfoCalled = false
  var infoIds: String = String()
  
  func fetchExchangesInfo(ids: String) async throws -> [String: ExchangeInfoModel]? {
    isFetchExchangesInfoCalled = true
    infoIds = ids
    
    switch infoResultToReturn {
    case .success(let models):
      return models
    case .failure(let error):
      throw error
    }
  }
  
  var assetsResultToReturn: Result<[ExchangeAssetsModel], Error> = .success(
    [ExchangeAssetsModel.mock]
  )
  var isFetchExchangesAssetsCalled = false
  var assetsId: String = String()
  
  func fetchExchangesAssets(id: String) async throws -> [ExchangeAssetsModel] {
    isFetchExchangesAssetsCalled = true
    assetsId = id
    
    switch assetsResultToReturn {
    case .success(let models):
      return models
    case .failure(let error):
      throw error
    }
  }
}
