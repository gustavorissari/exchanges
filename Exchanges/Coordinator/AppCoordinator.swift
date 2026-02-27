import UIKit

protocol AppCoordinatorFactory {
  func makeExchangeCoordinator(navigationController: UINavigationController, service: ExchangeServiceProtocol) -> Coordinator
}

final class AppCoordinator: Coordinator {
  var navigationController: UINavigationController
  private(set) var childCoordinators: [Coordinator] = []
  private let service: ExchangeServiceProtocol
  private let factory: AppCoordinatorFactory
  private var hasStarted = false
  
  init(
    navigationController: UINavigationController,
    service: ExchangeServiceProtocol,
    factory: AppCoordinatorFactory = DefaultAppCoordinatorFactory()
  ) {
    self.navigationController = navigationController
    self.service = service
    self.factory = factory
  }
  
  func start() {
    guard !hasStarted else { return }
    hasStarted = true
    showExchangeList()
  }
  
  func didFinish(_ coordinator: Coordinator) {
    removeChild(coordinator)
  }
  
  private func showExchangeList() {
    let exchangeCoordinator = factory.makeExchangeCoordinator(
      navigationController: navigationController,
      service: service
    )
    
    addChild(exchangeCoordinator)
    exchangeCoordinator.start()
  }
  
  private func addChild(_ coordinator: Coordinator) {
    childCoordinators.append(coordinator)
  }
  
  private func removeChild(_ coordinator: Coordinator) {
    childCoordinators.removeAll { $0 === coordinator }
  }
}
