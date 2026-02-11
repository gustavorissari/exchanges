import Foundation

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
