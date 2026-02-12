import Foundation

@MainActor
final class ExchangeListViewModel {
  
  private var orderedExchanges: [ExchangeInfoModel] = []
  weak var coordinator: ExchangeCoordinator?
  private let service: ExchangeServiceProtocol
  
  var onDataUpdated: (() -> Void)?
  var onError: ((String) -> Void)?
  var onLoadingStatusChanged: ((Bool) -> Void)?
  
  init(service: ExchangeServiceProtocol) {
    self.service = service
  }
  
  var numberOfRows: Int {
    orderedExchanges.count
  }
  
  func getExchangeInfo(at index: Int) -> ExchangeInfoModel? {
    guard orderedExchanges.indices.contains(index) else { return nil }
    return orderedExchanges[index]
  }
  
  func fetchExchangesMap() async {
    onLoadingStatusChanged?(true)
    defer { onLoadingStatusChanged?(false) }
    
    do {
      let fetchedExchangesMap = try await service.fetchExchangesMap()
      
      let idsString = fetchedExchangesMap
        .filter { $0.isActive == 1 }
        .compactMap { $0.id }
        .map(String.init)
        .joined(separator: ",")
      
      let fetchedExchangesInfo = try await service.fetchExchangesInfo(ids: idsString)
      
      handleSuccess(exchangesInfo: fetchedExchangesInfo)
    } catch {
      handleFailure(error: error)
    }
  }
  
  private func handleSuccess(exchangesInfo: [String: ExchangeInfoModel]?) {
    orderedExchanges = exchangesInfo?
      .values
      .sorted { ($0.spotVolumeUsd ?? 0) > ($1.spotVolumeUsd ?? 0) } ?? []
    
    onDataUpdated?()
  }
  
  private func handleFailure(error: Error) {
    onError?(error.localizedDescription)
  }
  
  func didSelectExchange(at index: Int) {
    guard orderedExchanges.indices.contains(index) else { return }
    coordinator?.goToDetails(with: orderedExchanges[index])
  }
}
