import Foundation
@testable import Exchanges

extension ExchangeAssetsModel {
  static var mock: ExchangeAssetsModel {
    return ExchangeAssetsModel(
      currency: .mock
    )
  }
}
