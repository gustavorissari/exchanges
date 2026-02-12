import Foundation

// MARK: - Protocol
protocol ExchangeServiceProtocol {
  func fetchExchangesMap() async throws -> [ExchangeMapModel]
  func fetchExchangesInfo(ids: String) async throws -> [String: ExchangeInfoModel]?
  func fetchExchangesAssets(id: String) async throws -> [ExchangeAssetsModel]
}

// MARK: - Service
final class ExchangeService: ExchangeServiceProtocol {
  
  private let networkManager: NetworkManagerProtocol
  
  init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
    self.networkManager = networkManager
  }
  
  // MARK: - Routes
  enum Route {
    case map
    case info(ids: String)
    case assets(id: String)
    
    var path: String {
      switch self {
      case .map: return "/v1/exchange/map"
      case .info(let ids): return "/v1/exchange/info?id=\(ids)"
      case .assets(let id): return "/v1/exchange/assets?id=\(id)"
      }
    }
  }
  
  func fetchExchangesMap() async throws -> [ExchangeMapModel] {
    let response: ResponseDTO<[ExchangeMapModel]> = try await networkManager.request(
      endpoint: Route.map.path,
      method: .GET
    )
    
    return response.data
  }
  
  func fetchExchangesInfo(ids: String) async throws -> [String: ExchangeInfoModel]? {
    let response: ResponseDTO<[String: ExchangeInfoModel]> = try await networkManager.request(
      endpoint: Route.info(ids: ids).path,
      method: .GET
    )
    
    return response.data
  }
  
  func fetchExchangesAssets(id: String) async throws -> [ExchangeAssetsModel] {
    let response: ResponseDTO<[ExchangeAssetsModel]> = try await networkManager.request(
      endpoint: Route.assets(id: id).path,
      method: .GET
    )
    
    return response.data
  }
}
