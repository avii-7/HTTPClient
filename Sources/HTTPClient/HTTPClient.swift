import Foundation

public class HTTPClient {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func hit<T: Decodable>(restRequest: HTTPRequest) async throws(NetworkError) -> T {
        
        let request = try prepareURLRequest(from: restRequest)
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await urlSession.data(for: request)
        }
        catch {
            throw handleError(error)
        }
        try handleResponse(response, data: data, urlRequest: request)
        return try decodeResponse(data: data)
    }
    
    public func hit(restRequest: HTTPRequest) async throws(NetworkError) {
        
        let request = try prepareURLRequest(from: restRequest)
        
        let (data, response): (Data, URLResponse)
        
        do {
            (data, response) = try await urlSession.data(for: request)
        }
        catch {
            throw handleError(error)
        }
        try handleResponse(response, data: data, urlRequest: request)
    }
}

extension HTTPClient {
    
    private func prepareURLRequest(from request: HTTPRequest) throws(NetworkError) -> URLRequest {
        
        let completeURL: URL?

        if #available(iOS 16.0, macOS 13, *)  {
            var url = request.baseURL.appending(path: request.endPoint)
            if let queryParams = request.queryParams {
                url = url.appending(queryItems: queryParams)
            }
            completeURL = url
        } else {
            let url = request.baseURL.appendingPathComponent(request.endPoint, isDirectory: false)
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = request.queryParams
            completeURL = urlComponents?.url
        }
        
        guard let completeURL else {
            throw .badURL
        }
        
        var urlRequest = URLRequest(url: completeURL)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        do {
            if let body = request.body {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            }
            return urlRequest
        }
        catch {
            throw .bodyEncodingError(description: error.localizedDescription)
        }
    }
    
    private func handleResponse(_ response: URLResponse, data: Data, urlRequest: URLRequest) throws(NetworkError) {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverUnreachable
        }
        
        if 200...299 ~= httpResponse.statusCode {
            return
        }
        else {
            logDetails(urlRequest: urlRequest, responseData: data, httpResponse: httpResponse)
            try handleHTTPResponseError(httpResponse)
        }
    }
    
    private func handleHTTPResponseError(_ httpResponse: HTTPURLResponse) throws(NetworkError) {
        if 500...599 ~= httpResponse.statusCode {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        } else if httpResponse.statusCode == 429 {
            throw NetworkError.rateLimited
        } else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    private func decodeResponse<T: Decodable>(data: Data) throws(NetworkError) -> T {
        do {
            if String.self == T.self {
                return String(decoding: data, as: UTF8.self) as! T
            }
            else {
                return try JSONDecoder().decode(T.self, from: data)
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
    
    private func logDetails(urlRequest: URLRequest, responseData: Data, httpResponse: HTTPURLResponse) {
        print("URL: \(urlRequest.url?.absoluteString ?? "Unknown URL")")
        print("HTTP Method: \(urlRequest.httpMethod ?? "Unknown Method")")
        print("Status Code: \(httpResponse.statusCode)")
        if let requestBody = urlRequest.httpBody {
            let requestBodyString = String(data: requestBody, encoding: .utf8) ?? "Could not decode request body"
            print("Request Body: \(requestBodyString)")
        }
        let responseBody = String(data: responseData, encoding: .utf8) ?? "Could not decode response"
        print("Response Body: \(responseBody)")
    }
}
