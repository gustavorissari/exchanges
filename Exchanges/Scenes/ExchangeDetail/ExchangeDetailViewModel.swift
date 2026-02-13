import Foundation

@MainActor
final class ExchangeDetailViewModel {
  
  // MARK: - Properties
  private let exchangeInfo: ExchangeInfoModel
  private(set) var currencies: [CurrencyModel] = []
  private let service: ExchangeServiceProtocol
  
  // MARK: - Callbacks
  var onCurrenciesUpdated: (() -> Void)?
  var onError: ((String) -> Void)?
  var onLoadingStatusChanged: ((Bool) -> Void)?
  
  // MARK: - Init
  init(
    exchangeInfo: ExchangeInfoModel,
    service: ExchangeServiceProtocol
  ) {
    self.exchangeInfo = exchangeInfo
    self.service = service
  }
  
  // MARK: - Basic Info Outputs
  var id: String {
    exchangeInfo.id ?? String()
  }
  
  var name: String { exchangeInfo.name ?? String() }
  
  var logoUrl: String? { exchangeInfo.logo }
  
  var description: String {
    exchangeInfo.description ?? L10n.EmptyText.empty
  }
  
  var websiteUrl: String {
    exchangeInfo.urls?.website?.first ?? L10n.EmptyText.empty
  }
  
  var volume: String {
    exchangeInfo.spotVolumeUsd?.toCurrency() ?? L10n.EmptyText.empty
  }
  
  var launchDate: String {
    exchangeInfo.dateLaunched?.toDisplayDate() ?? L10n.EmptyText.empty
  }
  
  // MARK: - Fee Outputs
  var makerFee: String {
    guard let fee = exchangeInfo.makerFee else { return L10n.EmptyText.empty }
    
    return "\(fee)%"
  }
  
  var takerFee: String {
    guard let fee = exchangeInfo.takerFee else { return L10n.EmptyText.empty }
    
    return "\(fee)%"
  }
  
  func fetchExchangesAssets() async {
    onLoadingStatusChanged?(true)
    defer { onLoadingStatusChanged?(false) }
    
    do {
      let exchangeAssets = try await service.fetchExchangesAssets(id: id)
      handleSuccess(exchangeAssets: exchangeAssets)
    } catch {
      handleFailure(error: error)
    }
  }
  
  private func handleSuccess(exchangeAssets: [ExchangeAssetsModel]) {
    exchangeAssets.forEach { exchangeAsset in
      guard let currency = exchangeAsset.currency else { return }
      
      currencies.append(currency)
    }
    onCurrenciesUpdated?()
  }
  
  private func handleFailure(error: Error) {
    onError?(error.localizedDescription)
  }
}
