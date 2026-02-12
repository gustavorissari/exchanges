struct ResponseDTO<T: Decodable>: Decodable {
  let data: T
  let status: StatusDTO?
}
