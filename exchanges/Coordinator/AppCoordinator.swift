import UIKit

final class AppCoordinator: Coordinator {
  
  // MARK: - Properties
  var navigationController: UINavigationController
  
  private var childCoordinators: [Coordinator] = []
  
  // MARK: - Init
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Start
  func start() {
    showExchangeList()
  }
  
  // MARK: - Navigation Methods
  private func showExchangeList() {
    let exchangeCoordinator = ExchangeCoordinator(navigationController: navigationController)
    
    childCoordinators.append(exchangeCoordinator)
    
    exchangeCoordinator.start()
  }
}
