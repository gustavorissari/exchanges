import UIKit

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = []
    private let service: ExchangeServiceProtocol

    init(
        navigationController: UINavigationController,
        service: ExchangeServiceProtocol
    ) {
        self.navigationController = navigationController
        self.service = service
    }

    func start() {
        showExchangeList()
    }

    private func showExchangeList() {
        let exchangeCoordinator = ExchangeCoordinator(
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
