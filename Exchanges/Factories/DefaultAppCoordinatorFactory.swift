import UIKit

struct DefaultAppCoordinatorFactory: AppCoordinatorFactory {
  func makeExchangeCoordinator(navigationController: UINavigationController, service: ExchangeServiceProtocol) -> Coordinator {
    ExchangeCoordinator(navigationController: navigationController, service: service)
  }
}
