import Foundation

final class ExchangeDetailViewModel {
  
  // MARK: - Properties
  private let exchangeInfo: ExchangeInfoModel
  private(set) var currencies: [CurrencyModel] = []
  
  // MARK: - Callbacks
  var onCurrenciesUpdated: (() -> Void)?
  var onError: ((String) -> Void)?
  var onLoadingStatusChanged: ((Bool) -> Void)?
  
  // MARK: - Init
  init(exchangeInfo: ExchangeInfoModel) {
    self.exchangeInfo = exchangeInfo
  }
  
  // MARK: - Basic Info Outputs
  var id: String {
    return "\(exchangeInfo.id ?? 0)"
  }
  
  var name: String { exchangeInfo.name ?? "Unknown" }
  
  var logoUrl: String? { exchangeInfo.logo }
  
  var description: String {
    exchangeInfo.description ?? "No description available."
  }
  
  var websiteUrl: String? {
    return exchangeInfo.urls?.website?.first
  }
  
  var volume: String {
    return exchangeInfo.spotVolumeUsd?.toCurrency() ?? "N/A"
  }
  
  var launchDate: String {
    return exchangeInfo.dateLaunched?.toDisplayDate() ?? "N/A"
  }
  
  // MARK: - Fee Outputs
  var makerFee: String {
    guard let fee = exchangeInfo.makerFee else { return "0.0%" }
    return "\(fee)%"
  }
  
  var takerFee: String {
    guard let fee = exchangeInfo.takerFee else { return "0.0%" }
    return "\(fee)%"
  }
  
  // MARK: - Currencies Logic
  /// Método para atualizar a lista de moedas após a chamada do Service
  func updateCurrencies(_ currencies: [CurrencyModel]) {
    self.currencies = currencies
    self.onCurrenciesUpdated?()
  }
}
