import Foundation

public class HTTPClient {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Executes an HTTP request and decodes the response into a specified `Decodable` type.
    public func execute<T: Decodable>(httpRequest: HTTPRequest) async throws(NetworkError) -> T {
        let urlRequest = try prepareURLRequest(from: httpRequest)
        let data = try await hit(urlRequest: urlRequest)
        return try decodeResponse(data: data, decoder: httpRequest.decoder ?? JSONDecoder())
    }
    
    /// Executes an HTTP request without expecting a response body.
    public func execute(httpRequest: HTTPRequest) async throws(NetworkError) {
        let urlRequest = try prepareURLRequest(from: httpRequest)
        try await hit(urlRequest: urlRequest)
    }

    /// Executes a multipart HTTP request and decodes the response.
    public func execute<T: Decodable>(httpRequest: HTTPRequest, multipartFormData: MultipartFormData) async throws(NetworkError) -> T {
        let urlRequest = try prepareMultiPartURLRequest(httpRequest: httpRequest, multipartFormData: multipartFormData)
        let data = try await hit(urlRequest: urlRequest)
        return try decodeResponse(data: data, decoder: httpRequest.decoder ?? JSONDecoder())
    }
    
    @discardableResult
    private func hit(urlRequest: URLRequest) async throws(NetworkError) -> Data {
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        }
        catch {
            throw handleError(error)
        }
        
        try handleResponse(response, data: data, urlRequest: urlRequest)
        return data
    }
}

extension HTTPClient {
    
    /// Decodes the response using the decoder provided in the request,
    /// or creates a new one if none is found.
    private func decodeResponse<T: Decodable>(data: Data, decoder: JSONDecoder) throws(NetworkError) -> T {
        do {
            if String.self == T.self {
                return String(decoding: data, as: UTF8.self) as! T
            }
            else {
                return try decoder.decode(T.self, from: data)
            }
        }
        catch {
            throw NetworkError.responseDecodingError(description: error.localizedDescription)
        }
    }
    
    private func handleError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            case .cannotFindHost, .cannotConnectToHost:
                return .serverUnreachable
            default:
                return .requestFailed(error: urlError)
            }
        }
        return .requestFailed(error: error)
    }
}
