import SafariServices
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
    let viewModel = ExchangeDetailViewModel(exchangeInfo: exchangeInfo)
    let viewController = ExchangeDetailViewController(viewModel: viewModel)
    viewController.coordinator = self
    
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension ExchangeCoordinator {
  func openWebsite(urlPath: String) {
    guard let url = URL(string: urlPath) else {
      print("URL Inválida: \(urlPath)")
      return
    }
    
    let safariVC = SFSafariViewController(url: url)
    safariVC.modalPresentationStyle = UIModalPresentationStyle.pageSheet
    navigationController.present(safariVC, animated: true)
  }
}
