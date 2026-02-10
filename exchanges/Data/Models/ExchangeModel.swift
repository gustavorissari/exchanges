import Foundation

// MARK: - ExchangeModel
struct ExchangeModel: Decodable {
  let id: String?
  let name: String
  let logo: String?
  let spotVolumeUsd: Double?
  let dateLaunched: String?
  let description: String?
  let urls: ExchangeUrls?
  let makerFee: Double?
  let takerFee: Double?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case logo
    case description
    case urls
    case spotVolumeUsd = "spot_volume_usd"
    case dateLaunched = "date_launched"
    case makerFee = "maker_fee"
    case takerFee = "taker_fee"
  }
}

struct ExchangeUrls: Decodable {
    let website: [String]?
}

// MARK: - Currency (For the detail list)
struct Currency: Decodable {
  let name: String
  let priceUsd: Double?
  
  enum CodingKeys: String, CodingKey {
    case name
    case priceUsd = "price_usd"
  }
}
