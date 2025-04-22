import Foundation

enum NetworkError: Error {
    case codeError(message: String)
    case invalidStatusCode(message: String)
    case noData(message: String)
    case decodingError(message: String)
}
