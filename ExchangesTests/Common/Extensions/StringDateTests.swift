import XCTest
@testable import Exchanges

final class StringDateTests: XCTestCase {
  
  func test_toDisplayDate_withValidISO8601Date_shouldFormatToMediumStyle() {
    // Given
    let isoDate = "2024-05-15T10:30:00.000Z"
    
    // When
    let result = isoDate.toDisplayDate()
    
    // Then
    XCTAssertEqual(result, "May 15, 2024")
  }
  
  func test_toDisplayDate_withInvalidFormat_shouldReturnOriginalString() {
    // Given
    let invalidDate = "15/05/2024"
    
    // When
    let result = invalidDate.toDisplayDate()
    
    // Then
    XCTAssertEqual(result, invalidDate)
  }
  
  func test_toDisplayDate_withEmptyString_shouldReturnEmptyString() {
    // Given
    let emptyString = ""
    
    // When
    let result = emptyString.toDisplayDate()
    
    // Then
    XCTAssertEqual(result, "")
  }
  
  func test_toDisplayDate_withoutFractionalSeconds_shouldStillWorkIfPossible() {
    // Given
    let dateWithoutMillis = "2024-05-15T10:30:00Z"
    
    // When
    let result = dateWithoutMillis.toDisplayDate()
    
    // Then
    XCTAssertEqual(result, dateWithoutMillis)
  }
}
