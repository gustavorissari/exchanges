import UIKit

final class MockViewController: UIViewController {
    var viewDidLoadCalled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadCalled = true
    }
}
