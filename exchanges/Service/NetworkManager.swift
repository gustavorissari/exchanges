import Foundation

enum NetworkError: Error {
  case invalidURL
  case noData
  case decodingError
  case serverError(String)
  case unauthorized
}

protocol NetworkManagerProtocol {
  func request<T: Decodable>(
    endpoint: String,
    method: String,
    completion: @escaping (Result<T, NetworkError>) -> Void
  )
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
    method: String = "GET",
    completion: @escaping (Result<T, NetworkError>) -> Void
  ) {
    guard let url = URL(string: baseURL + endpoint) else {
      completion(.failure(.invalidURL))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(.serverError(error.localizedDescription)))
        return
      }
      
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
        completion(.failure(.unauthorized))
        return
      }
      
      guard let data = data else {
        completion(.failure(.noData))
        return
      }
      
      // REMOVE
      if let jsonObject = try? JSONSerialization.jsonObject(with: data),
         let prettyData = try? JSONSerialization.data(
              withJSONObject: jsonObject,
              options: .prettyPrinted
         ),
         let jsonString = String(data: prettyData, encoding: .utf8) {

          print(jsonString)
      }
      // REMOVE
      
      do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        DispatchQueue.main.async {
          completion(.success(decodedData))
        }
      } catch {
        print("Decoding error: \(error)")
        completion(.failure(.decodingError))
      }
    }.resume()
  }
}
