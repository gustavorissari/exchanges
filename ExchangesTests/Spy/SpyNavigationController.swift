import UIKit

final class SpyNavigationController: UINavigationController {
  var pushedViewController: UIViewController?
  var presentedVC: UIViewController?
  var pushCount = 0
  
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    pushedViewController = viewController
    pushCount += 1
    super.pushViewController(viewController, animated: animated)
  }
  
  override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    presentedVC = viewControllerToPresent
    super.present(viewControllerToPresent, animated: flag, completion: completion)
  }
}
