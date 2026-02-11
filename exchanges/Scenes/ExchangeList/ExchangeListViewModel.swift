import Foundation

final class ExchangeListViewModel {
  
  // MARK: - Properties
  private var orderedExchanges: [ExchangeInfoModel] = []
  weak var coordinator: ExchangeCoordinator?
  private let service: ExchangeService
  
  // MARK: - Callbacks
  var onDataUpdated: (() -> Void)?
  var onError: ((String) -> Void)?
  var onLoadingStatusChanged: ((Bool) -> Void)?
  
  // MARK: - Init
  init(service: ExchangeService = ExchangeService()) {
    self.service = service
  }
  
  // MARK: - TableView Data Accessors
  var numberOfRows: Int {
    orderedExchanges.count
  }
  
  func getExchangeInfo(at index: Int) -> ExchangeInfoModel? {
    orderedExchanges[index]
  }
  
  // MARK: - Networking
  func fetchExchangesMap() {
    Task { [weak self] in
      await MainActor.run { self?.onLoadingStatusChanged?(true) }
      
      do {
        guard let self = self else { return }
        
        let fetchedExchangesMap = try await service.fetchExchangesMap()
        let isActiveList = fetchedExchangesMap.filter { $0.isActive == 1 }
        let idsString = isActiveList.compactMap { String($0.id ?? 0) }.joined(separator: ",")
        let fetchedExchangesInfo = try await service.fetchExchangesInfo(ids: idsString)
        
        await MainActor.run {
          let exchangesInfo = fetchedExchangesInfo ?? [:]
          self.orderedExchanges = exchangesInfo.values.sorted { ($0.spotVolumeUsd ?? 0) > ($1.spotVolumeUsd ?? 0) }
          self.onDataUpdated?()
          self.onLoadingStatusChanged?(false)
        }
        
      } catch {
        await MainActor.run {
          self?.onError?(error.localizedDescription)
          self?.onLoadingStatusChanged?(false)
        }
      }
    }
  }
  
  // MARK: - Navigation
  func didSelectExchange(at index: Int) {
    let selectedExchangeInfo = orderedExchanges[index]
    coordinator?.goToDetails(with: selectedExchangeInfo)
  }
}
