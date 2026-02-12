import UIKit
@testable import Exchanges

final class MockExchangeFactory: ExchangeFactory {
  func makeExchangeList(service: ExchangeServiceProtocol, coordinator: ExchangeCoordinator) -> UIViewController {
    return MockViewController()
  }
  
  func makeExchangeDetail(exchangeInfo: ExchangeInfoModel, service: ExchangeServiceProtocol, coordinator: ExchangeCoordinator) -> UIViewController {
    return MockViewController()
  }
}
