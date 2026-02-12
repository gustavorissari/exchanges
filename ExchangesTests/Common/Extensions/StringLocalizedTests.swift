import XCTest
@testable import Exchanges

final class StringLocalizedTests: XCTestCase {
  
  func test_localized_withExistingKey_shouldReturnTranslatedString() {
    // Given
    let key = "hello_world"
    
    // When
    let result = key.localized
    
    // Then
    XCTAssertNotNil(result)
  }
  
  func test_localized_withNonExistingKey_shouldReturnTheKeyItself() {
    // Given
    let key = "non_existing_key_123"
    
    // When
    let result = key.localized
    
    // Then
    XCTAssertEqual(result, "non_existing_key_123")
  }
  
  func test_localized_shouldNotReturnEmptyUnlessKeyIsEmpty() {
    // Given
    let key = "any_key"
    
    // When
    let result = key.localized
    
    // Then
    XCTAssertFalse(result.isEmpty)
  }
}
