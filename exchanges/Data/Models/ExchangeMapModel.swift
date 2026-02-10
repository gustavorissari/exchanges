import Foundation

// MARK: - Root Object
struct CMCResponse: Decodable {
  let data: [ExchangeMapModel]
  let status: CMCStatus?
}

// MARK: - Status
struct CMCStatus: Decodable {
  let timestamp: String?
  let errorCode: Int?
  let errorMessage: String?
  let elapsed: Int?
  let creditCount: Int?
  let notice: String?
  
  enum CodingKeys: String, CodingKey {
    case timestamp, elapsed, notice
    case errorCode = "error_code"
    case errorMessage = "error_message"
    case creditCount = "credit_count"
  }
}

// MARK: - Exchange Map Model
struct ExchangeMapModel: Decodable {
  let id: Int?
  let name: String?
  let slug: String?
  let isActive: Int?
  let firstHistoricalData: String?
  let lastHistoricalData: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name, slug
    case isActive = "is_active"
    case firstHistoricalData = "first_historical_data"
    case lastHistoricalData = "last_historical_data"
  }
}
