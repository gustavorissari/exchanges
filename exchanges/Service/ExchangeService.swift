import Foundation

// MARK: - Service Error
enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
  case serverError(String)
}

// MARK: - Protocol
protocol ExchangeServiceProtocol {
  func fetchExchanges(completion: @escaping (Result<[ExchangeModel], NetworkError>) -> Void)
  func fetchAssets(for exchangeId: Int, completion: @escaping (Result<[ExchangeModel], NetworkError>) -> Void)
}

// MARK: - Service
final class ExchangeService: ExchangeServiceProtocol {
  
  private let session: URLSession
  
  // MARK: - API Constants
  private let baseURL = "https://pro-api.coinmarketcap.com"
  private let apiKey = "YOUR_API_KEY_HERE"
  
  // MARK: - Routes
  enum Route {
    case info
    case assets(id: Int)
    
    var path: String {
      switch self {
      case .info: return "/v1/exchange/info"
      case .assets(let id): return "/v1/exchange/assets?id=\(id)"
      }
    }
  }
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func fetchExchanges(completion: @escaping (Result<[ExchangeModel], NetworkError>) -> Void) {
    guard let url = URL(string: baseURL + Route.info.path) else {
      completion(.failure(.invalidURL))
      return
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
    request.httpMethod = "GET"
    
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(.serverError(error.localizedDescription)))
        return
      }
      
      guard let data = data else {
        completion(.failure(.noData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        // If you didn't use CodingKeys for everything, you could use:
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let exchanges = try decoder.decode([ExchangeModel].self, from: data)
        completion(.success(exchanges))
      } catch {
        print("Decoding error: \(error)")
        completion(.failure(.decodingError))
      }
    }.resume()
  }
  
  func fetchAssets(for exchangeId: Int, completion: @escaping (Result<[ExchangeModel], NetworkError>) -> Void) {
    let urlString = baseURL + Route.assets(id: exchangeId).path
    
    guard let url = URL(string: urlString) else {
      completion(.failure(.invalidURL))
      return
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    request.httpMethod = "GET"
    
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(.serverError(error.localizedDescription)))
        return
      }
      
      guard let data = data else {
        completion(.failure(.noData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        // IMPORTANT: CMC info/assets returns a "data" wrapper dictionary.
        // You might need a wrapper struct like CMCResponse<T>: Decodable
        let exchanges = try decoder.decode([ExchangeModel].self, from: data)
        completion(.success(exchanges))
      } catch {
        completion(.failure(.decodingError))
      }
    }.resume()
  }
}
