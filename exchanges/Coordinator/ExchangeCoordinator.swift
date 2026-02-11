import UIKit

class ExchangeCoordinator: Coordinator {
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewModel = ExchangeListViewModel()
    viewModel.coordinator = self
    let viewController = ExchangeListViewController(viewModel: viewModel)
    
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func goToDetails(with exchangeInfo: ExchangeInfoModel) {
//    let viewModel = ExchangeDetailViewModel(exchange: exchange)
//    let viewController = ExchangeDetailViewController(viewModel: viewModel)
//
//    navigationController.pushViewController(viewController, animated: true)
  }
}
