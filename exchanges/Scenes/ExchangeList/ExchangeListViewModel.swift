import Foundation

final class ExchangeListViewModel {
  
  // MARK: - Properties
  private var exchangesInfo: [String: ExchangeInfoModel] = [:]
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
    exchangesInfo.count
  }
  
  func getExchangeInfo(at id: Int) -> ExchangeInfoModel? {
    exchangesInfo["\(id)"]
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
          self.exchangesInfo = fetchedExchangesInfo ?? [:]
          self.onDataUpdated?()
          self.onLoadingStatusChanged?(false)
        }
        
      } catch {
        print("DEBUG: \(error.localizedDescription)")
        await MainActor.run {
          self?.onError?(error.localizedDescription)
          self?.onLoadingStatusChanged?(false)
        }
      }
    }
  }
  
  // MARK: - Navigation
  func didSelectExchange(at id: Int) {
    guard let selectedExchangeInfo = exchangesInfo["\(id)"] else { return }
    coordinator?.goToDetails(with: selectedExchangeInfo)
  }
}
