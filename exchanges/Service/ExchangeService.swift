import Foundation

// MARK: - Protocol
protocol ExchangeServiceProtocol {
  func fetchExchangesMap(completion: @escaping (Result<[ExchangeMapModel], NetworkError>) -> Void)
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
    case info(id: Int)
    case assets(id: Int)
    
    var path: String {
      switch self {
      case .map: return "/v1/exchange/map"
      case .info(let id): return "/v1/exchange/info?id=\(id)"
      case .assets(let id): return "/v1/exchange/assets?id=\(id)"
      }
    }
  }
  
  func fetchExchangesMap(completion: @escaping (Result<[ExchangeMapModel], NetworkError>) -> Void) {
    networkManager.request(endpoint: Route.map.path, method: "GET") { (result: Result<CMCResponse, NetworkError>) in
      switch result {
      case .success(let response):
        completion(.success(response.data))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
