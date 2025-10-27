import Foundation

public protocol UrlencodeCodingKeys: CaseIterable, CodingKey {
    
    var key: String { get }
}

public protocol UrlencodeRepresentable: Encodable {

    associatedtype CodingKeyType: UrlencodeCodingKeys
    
    func getFormUrlEncoded() -> Data?
}

extension UrlencodeRepresentable {
    
    func getFormUrlEncoded() -> Data? {

        let type = Mirror(reflecting: self)
        
        var queryItems: [URLQueryItem] = []

        for child in type.children {
            
            guard let label = child.label else { continue }
            
            guard
                let convertible = child.value as? CustomStringConvertible,
                convertible.description.isEmpty == false
            else { continue }
            
            let value = convertible.description
            
            let enumCase = CodingKeyType.allCases.first { $0.stringValue == label }
            
            if let key = enumCase?.key {
                let item = URLQueryItem(name: key, value: value.description)
                queryItems.append(item)
            }
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        
        return urlComponents.percentEncodedQuery?.data(using: .utf8)
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// An enum representing an HTTP request.
///
/// For multipart requests, you don't need to include body, headers and encoder.
public protocol HTTPRequest {
    
    var endPoint: String { get }
    
    var body: Encodable? { get }
    
    var headers: [String: String]? { get }
    
    var httpMethod: HTTPMethod { get }
    
    var baseURL: URL { get }
    
    var queryParams: [URLQueryItem]? { get }
    
    var retry: Int { get }
    
    var urlEncode: (any UrlencodeRepresentable)? { get }
}

public extension HTTPRequest {
    
    var body: Encodable? { nil }
    
    var queryParams: [URLQueryItem]? { nil }
    
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    
    var retry: Int { 0 }
    
    var urlEncode: (any UrlencodeRepresentable)? { nil }
}
