import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// An enum representing an HTTP request.
///
/// For multipart requests, you do not need to include body, headers and encoder. It will be ignore.
public protocol HTTPRequest {
    
    var endPoint: String { get }
    
    var body: Encodable? { get }
    
    var headers: [String: String]? { get }
    
    var httpMethod: HTTPMethod { get }
    
    var baseURL: URL { get }
    
    var queryParams: [URLQueryItem]? { get }
    
    var encoder: JSONEncoder? { get }
    
    var decoder: JSONDecoder? { get }
}

public extension HTTPRequest {
    
    var body: Encodable? { nil }
    
    var queryParams: [URLQueryItem]? { nil }
    
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    
    var encoder: JSONEncoder? { JSONEncoder() }
    
    var decoder: JSONDecoder? { JSONDecoder() }
}
