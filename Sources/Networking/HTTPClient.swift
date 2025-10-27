import Foundation

public final class HTTPClient: Sendable {
    
    public static let `default`: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 30
        return URLSession(configuration: config)
    }()
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = HTTPClient.default) {
        self.urlSession = urlSession
    }
    
    /// Executes an HTTP request and decodes the response into a specified `Decodable` type.
    public func execute<T: Decodable>(httpRequest: HTTPRequest) async throws(NetworkError) -> T {
        let urlRequest = try prepareURLRequest(using: httpRequest)
        let response: T = try await perform(urlRequest: urlRequest)
        return response
    }
    
    private func performWithRetry<T>(urlRequest: URLRequest, retry: Int) async throws(NetworkError) -> T where T : Decodable {

           for _ in 0..<retry {
               do {
                   return try await perform(urlRequest: urlRequest)
               }
               catch NetworkError.unauthorized {
                   if #available(iOS 16.0, macOS 13, *) {
                       try? await Task.sleep(for: .seconds(0.5))
                   } else {
                       try? await Task.sleep(nanoseconds: 500_000_000)
                   }
                   continue
               }
           }
           
           return try await perform(urlRequest: urlRequest)
       }

    /// Executes a multipart HTTP request and decodes the response.
    public func execute<T: Decodable>(httpRequest: HTTPRequest, multipartFormData: MultipartFormData) async throws(NetworkError) -> T {
        let urlRequest = try prepareMultiPartURLRequest(httpRequest: httpRequest, multipartFormData: multipartFormData)
        let response: T = try await perform(urlRequest: urlRequest)
        return response
    }
    
    // Core function
      private func perform<T>(urlRequest: URLRequest) async throws(NetworkError) -> T where T : Decodable {
          do {
              let (data, response) = try await URLSession.shared.data(for: urlRequest)
              try checkStatusCode(response, data)
              return try JSONDecoder().decode(T.self, from: data)
          }
          // Errors are catched according to the `do` block code.
          catch let error as URLError {
              throw handleURLError(error)
          }
          catch let error as NetworkError {
              throw error
          }
          catch let error as DecodingError {
              throw handleDecodingError(error)
          }
          catch {
              throw .unknownError(error: error)
          }
      }
}
