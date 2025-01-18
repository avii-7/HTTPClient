import Foundation

public enum NetworkError: LocalizedError {
    case badURL
    case noInternetConnection
    case timeout
    case serverUnreachable
    case bodyEncodingError(description: String)
    case rateLimited
    case responseDecodingError(description: String)
    case serverError(statusCode: Int)
    case requestFailed(error: Error)
}

extension NetworkError {
    
    public var errorDescription: String? {
        switch self {
        case .badURL: "Bad URL"
        case .noInternetConnection: "No Internet Connection"
        case .timeout: "Timeout"
        case .serverUnreachable: "Server Unreachable"
        case .rateLimited: "Rate Limited"
        case .responseDecodingError(let description): "Response Decoding Error: \(description)"
        case .serverError(let statusCode): "Server Error \(statusCode)"
        case .requestFailed(let error): error.localizedDescription
        case .bodyEncodingError(description: let description): "Body Encoding Error \(description)"
        }
    }
}
