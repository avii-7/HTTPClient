import Foundation

public enum NetworkError: LocalizedError {
    case badURL
    case invalidJWTToken
    case invalidURL
    case noData
    case decodingError
    case noInternet
    case badRequest(data: Data)
    case retryLimitExceeded
    case unauthorized
    case sessionExpired
    case rateLimited
    case timeout
    case serverUnreachable
    case bodyEncodingError(error: Error)
    case responseDecodingError(description: String)
    case statusCode(code: Int, data: Data?)
    case cancelled
    case unknownError(error: Error?)
    
    public var errorDescription: String? {
        switch self {
        case .badURL: "Invalid URL."
        case .invalidJWTToken: "Invalid JWT Token."
        case .invalidURL: "Invalid URL."
        case .noData: "No data returned from the server."
        case .decodingError: "Failed to decode the data."
        case .noInternet: "No internet connection. Please try again."
        case .retryLimitExceeded: "Retry limit exceeded. Please try again later."
        case .unauthorized: "Unauthorized"
        case .sessionExpired: "Session expired"
        case .rateLimited: "Rate Limited"
        case .timeout: "Timeout"
        case .serverUnreachable: "Server Unreachable"
        case .bodyEncodingError(let error): "Body Encoding Error \(error.localizedDescription)"
        case .responseDecodingError(let description): "Response Decoding Error - \(description)"
        case .statusCode(let code, _): "Status Code Error \(code)"
        case .cancelled: "Request cancelled."
        case .unknownError(let error): "An unknown error occurred: \(error?.localizedDescription ?? "")"
        case .badRequest: "Bad Request"
        }
    }
}
