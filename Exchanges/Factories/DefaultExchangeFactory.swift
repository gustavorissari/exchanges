import UIKit

protocol ExchangeFactory {
  func makeExchangeList(service: ExchangeServiceProtocol, coordinator: ExchangeCoordinator) -> UIViewController
  func makeExchangeDetail(exchangeInfo: ExchangeInfoModel, service: ExchangeServiceProtocol, coordinator: ExchangeCoordinator) -> UIViewController
}

struct DefaultExchangeFactory: ExchangeFactory {
  func makeExchangeList(service: ExchangeServiceProtocol, coordinator: ExchangeCoordinator) -> UIViewController {
    let viewModel = ExchangeListViewModel(service: service)
    viewModel.coordinator = coordinator
    return ExchangeListViewController(viewModel: viewModel)
  }
  
  func makeExchangeDetail(exchangeInfo: ExchangeInfoModel, service: ExchangeServiceProtocol, coordinator: ExchangeCoordinator) -> UIViewController {
    let viewModel = ExchangeDetailViewModel(exchangeInfo: exchangeInfo, service: service)
    let viewController = ExchangeDetailViewController(viewModel: viewModel)
    viewController.coordinator = coordinator
    return viewController
  }
}
