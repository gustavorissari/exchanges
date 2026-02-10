import Foundation

final class ExchangeListViewModel {
  
  // MARK: - Properties
  private var exchanges: [ExchangeModel] = []
  weak var coordinator: ExchangeCoordinator?
  private let service: ExchangeService
  
  // MARK: - Callbacks (Bindings)
  var onDataUpdated: (() -> Void)?
  var onError: ((String) -> Void)?
  var onLoadingStatusChanged: ((Bool) -> Void)?
  
  // MARK: - Init
  init(service: ExchangeService = ExchangeService()) {
    self.service = service
  }
  
  // MARK: - TableView Data Accessors
  var numberOfRows: Int {
    return exchanges.count
  }
  
  func exchange(at index: Int) -> ExchangeModel {
    return exchanges[index]
  }
  
  // MARK: - Formatting Logic
  func getFormattedVolume(for index: Int) -> String {
    guard let volume = exchanges[index].spotVolumeUsd else { return "$ 0.00" }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.maximumFractionDigits = 2
    
    return formatter.string(from: NSNumber(value: volume)) ?? "$ 0.00"
  }
  
  // MARK: - Networking
  func fetchExchanges() {
    onLoadingStatusChanged?(true)
    
    service.fetchExchanges { [weak self] result in
      guard let self = self else { return }
      self.onLoadingStatusChanged?(false)
      
      switch result {
      case .success(let fetchedExchanges):
        self.exchanges = fetchedExchanges
        self.onDataUpdated?()
      case .failure(let error):
        self.onError?(error.localizedDescription)
      }
    }
  }
  
  // MARK: - Navigation
  func didSelectExchange(at index: Int) {
    let selectedExchange = exchanges[index]
    coordinator?.goToDetails(exchange: selectedExchange)
  }
}
