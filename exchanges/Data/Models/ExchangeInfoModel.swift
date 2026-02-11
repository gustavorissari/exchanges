import Foundation

struct ExchangeInfoModel: Decodable {
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
  
  // MARK: - Custom Init para tratar String/Int
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    if let idInt = try? container.decode(Int.self, forKey: .id) {
      id = String(idInt)
    } else if let idString = try? container.decode(String.self, forKey: .id) {
      id = idString
    } else {
      id = nil
    }
    
    logo = try container.decodeIfPresent(String.self, forKey: .logo)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    urls = try container.decodeIfPresent(ExchangeUrls.self, forKey: .urls)
    spotVolumeUsd = try container.decodeIfPresent(Double.self, forKey: .spotVolumeUsd)
    dateLaunched = try container.decodeIfPresent(String.self, forKey: .dateLaunched)
    makerFee = try container.decodeIfPresent(Double.self, forKey: .makerFee)
    takerFee = try container.decodeIfPresent(Double.self, forKey: .takerFee)
  }
}

struct ExchangeUrls: Decodable {
  let website: [String]?
}
