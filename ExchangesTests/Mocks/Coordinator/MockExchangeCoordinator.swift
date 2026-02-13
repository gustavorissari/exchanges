import Foundation
@testable import Exchanges

final class MockExchangeCoordinator: ExchangeCoordinator {
  var isGoToDetailsCalled = false
  var capturedExchange: ExchangeInfoModel?
  
  override func goToDetails(with exchange: ExchangeInfoModel) {
    isGoToDetailsCalled = true
    capturedExchange = exchange
  }
  
  var didOpenWebsiteCalled = false
  var capturedUrlPath: String?
  
  override func openWebsite(urlPath: String) {
    didOpenWebsiteCalled = true
    capturedUrlPath = urlPath
  }
}
