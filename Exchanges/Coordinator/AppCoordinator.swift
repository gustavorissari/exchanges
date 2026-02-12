import UIKit

protocol AppCoordinatorFactory {
    func makeExchangeCoordinator(navigationController: UINavigationController, service: ExchangeServiceProtocol) -> Coordinator
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let service: ExchangeServiceProtocol
    private let factory: AppCoordinatorFactory

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
        showExchangeList()
    }

    private func showExchangeList() {
        let exchangeCoordinator = factory.makeExchangeCoordinator(
            navigationController: navigationController,
            service: service
        )

        childCoordinators.append(exchangeCoordinator)
        exchangeCoordinator.start()
    }

    func didFinish(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
