import UIKit
@testable import Exchanges

final class MockAppCoordinatorFactory: AppCoordinatorFactory {
  var lastCreatedCoordinator: Coordinator?
  
  func makeExchangeCoordinator(navigationController: UINavigationController, service: ExchangeServiceProtocol) -> Coordinator {
    let mock = MockChildCoordinator(navigationController: navigationController)
    lastCreatedCoordinator = mock
    return mock
  }
}
