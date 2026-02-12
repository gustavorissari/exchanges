import UIKit
@testable import Exchanges

final class MockChildCoordinator: Coordinator {
  var navigationController: UINavigationController
  var startCalled = false
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    startCalled = true
  }
}
