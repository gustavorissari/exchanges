import Foundation
@testable import Exchanges

extension ExchangeInfoModel {
  static var mock: ExchangeInfoModel {
    return ExchangeInfoModel(
      id: "1",
      name: "Binance",
      logo: "https://example.com/logo.png",
      spotVolumeUsd: 1500000.0,
      dateLaunched: "2017-07-14",
      description: "World's largest exchange.",
      urls: ExchangeUrls(website: ["https://www.binance.com"]),
      makerFee: 0.01,
      takerFee: 0.01
    )
  }
}
