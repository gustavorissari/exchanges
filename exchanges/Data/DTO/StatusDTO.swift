struct StatusDTO: Decodable {
  let timestamp: String?
  let errorCode: Int?
  let errorMessage: String?
  let elapsed: Int?
  let creditCount: Int?
  let notice: String?
  
  enum CodingKeys: String, CodingKey {
    case timestamp, elapsed, notice
    case errorCode = "error_code"
    case errorMessage = "error_message"
    case creditCount = "credit_count"
  }
}
