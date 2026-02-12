struct ExchangeAssetsModel: Decodable {
  let currency: CurrencyModel?
  
  enum CodingKeys: String, CodingKey {
    case currency
  }
}
