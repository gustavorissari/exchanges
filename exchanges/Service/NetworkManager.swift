import Foundation

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
  case serverError(String)
  case unauthorized
}

enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
  case PATCH
}

protocol NetworkManagerProtocol {
  func request<T: Decodable>(endpoint: String, method: HTTPMethod) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
  
  static let shared = NetworkManager()
  private let session: URLSession
  
  private let baseURL = "https://pro-api.coinmarketcap.com"
  private let apiKey = "c6b7ba4023834514b8c5519fcb589c9c"
  
  private init(session: URLSession = .shared) {
    self.session = session
  }
  
  func request<T: Decodable>(
    endpoint: String,
    method: HTTPMethod = .GET
  ) async throws -> T {
    guard let url = URL(string: baseURL + endpoint) else { throw NetworkError.invalidURL }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
      let (data, response) = try await session.data(for: request)
      
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
        throw NetworkError.unauthorized
      }
      
      // Optional debug print (remove in production)
      if T.self is ResponseDTO<[String: ExchangeInfoModel]>.Type {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: .prettyPrinted
           ),
           let jsonString = String(data: prettyData, encoding: .utf8) {
          print(jsonString)
        }
      }
      // Optional debug print (remove in production)
      
      return try JSONDecoder().decode(T.self, from: data)
      
    } catch let error as DecodingError {
      switch error {
      case .keyNotFound(let key, _):
          print("❌ Chave não encontrada: \(key.stringValue)")
      case .typeMismatch(let type, let context):
          print("❌ Tipo errado: \(type) em \(context.codingPath)")
      case .valueNotFound(let type, let context):
          print("❌ Valor nulo onde não devia: \(type) em \(context.codingPath)")
      default:
          print("❌ Erro de decodificação: \(error)")
      }
      throw NetworkError.serverError("Erro de mapeamento")
    }
    catch let error as NetworkError {
      throw error
    } catch {
      throw NetworkError.serverError(error.localizedDescription)
    }
  }
}
