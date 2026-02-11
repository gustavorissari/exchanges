import Foundation

extension String {
  func toDisplayDate() -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    guard let date = isoFormatter.date(from: self) else { return self }
    
    let displayFormatter = DateFormatter()
    displayFormatter.dateStyle = .medium
    displayFormatter.locale = Locale(identifier: "pt_BR")
    return displayFormatter.string(from: date)
  }
}
