import UIKit

protocol ErrorAlertPresentable {
  func showError(title: String, message: String)
}

@MainActor
extension ErrorAlertPresentable where Self: UIViewController {
  func showError(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: L10n.Error.ok, style: .default))
    present(alert, animated: true)
  }
}
