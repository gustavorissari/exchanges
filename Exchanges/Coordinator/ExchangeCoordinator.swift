import SafariServices
import UIKit

class ExchangeCoordinator: Coordinator {
  var service: ExchangeServiceProtocol
  var navigationController: UINavigationController
  private let factory: ExchangeFactory
  
  init(
    navigationController: UINavigationController,
    service: ExchangeServiceProtocol,
    factory: ExchangeFactory = DefaultExchangeFactory()
  ) {
    self.navigationController = navigationController
    self.service = service
    self.factory = factory
  }
  
  func start() {
    let viewController = factory.makeExchangeList(service: service, coordinator: self)
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func goToDetails(with exchangeInfo: ExchangeInfoModel) {
    let viewController = factory.makeExchangeDetail(exchangeInfo: exchangeInfo, service: service, coordinator: self)
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension ExchangeCoordinator {
  func openWebsite(urlPath: String) {
    guard let url = URL(string: urlPath) else { return }
    
    let safariVC = SFSafariViewController(url: url)
    safariVC.modalPresentationStyle = .pageSheet
    navigationController.present(safariVC, animated: true)
  }
}
