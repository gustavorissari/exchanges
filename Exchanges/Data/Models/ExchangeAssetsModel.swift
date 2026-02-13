struct ExchangeAssetsModel: Decodable {
  let currency: CurrencyModel?
  
  enum CodingKeys: String, CodingKey {
    case currency
  }
}

extension ExchangeAssetsModel {
  static var mock: ExchangeAssetsModel {
    return ExchangeAssetsModel(
      currency: .mock
    )
  }
}
