import Foundation
@testable import Exchanges

extension CurrencyModel {
  static var mock: CurrencyModel {
    return CurrencyModel(
      name: "Coin",
      priceUsd: 150.0
    )
  }
}
