import Foundation

struct ExchangeMapModel: Decodable {
  let id: Int?
  let isActive: Int?
  
  enum CodingKeys: String, CodingKey {
    case id
    case isActive = "is_active"
  }
}

extension ExchangeMapModel {
  static var mock: ExchangeMapModel {
    return ExchangeMapModel(
      id: 1,
      isActive: 1
    )
  }
}
