import XCTest
@testable import Exchanges

final class DoubleCurrencyTests: XCTestCase {
  
  func test_toCurrency_withPositiveValue_shouldFormatCorrectly() {
    // Given
    let value: Double = 1234.56
    
    // When
    let result = value.toCurrency()
    
    // Then
    XCTAssertTrue(result.contains("$"))
    XCTAssertTrue(result.contains("1,234.56"))
  }
  
  func test_toCurrency_withZero_shouldReturnZeroFormatted() {
    // Given
    let value: Double = 0.0
    
    // When
    let result = value.toCurrency()
    
    // Then
    XCTAssertTrue(result.contains("0.00"))
  }
  
  func test_toCurrency_withNegativeValue_shouldIncludeMinusSign() {
    // Given
    let value: Double = -50.0
    
    // When
    let result = value.toCurrency()
    
    // Then
    XCTAssertTrue(result.contains("-"))
    XCTAssertTrue(result.contains("50.00"))
  }
  
  func test_toCurrency_shouldRoundToTwoDecimalPlaces() {
    // Given
    let value: Double = 10.555
    
    // When
    let result = value.toCurrency()
    
    // Then
    XCTAssertTrue(result.contains("10.56"))
  }
}
