//
//  HTTPClient+Helpers.swift
//  HTTPClient
//
//  Created by Avii 🔥 on 26/10/25.
//

import Foundation

// MARK: - Helper Functions
internal extension HTTPClient {
    
    func prepareURLRequest(using request: HTTPRequest) throws(NetworkError) -> URLRequest {

        do {
            var urlRequest = try prepareURLRequestWithoutBody(using: request)
            
            if let formDataBody = request.urlEncode {
                urlRequest.httpBody = formDataBody.getFormUrlEncoded()
            }
            else if let postBody = request.body {
                let encoder = JSONEncoder()
                urlRequest.httpBody = try encoder.encode(postBody)
            }
            
            debugPrint("📡 cURL Request:\n\(urlRequest)")
            return urlRequest
        }
        catch {
            throw .bodyEncodingError(error: error)
        }
    }
    
    func prepareMultiPartURLRequest(httpRequest: HTTPRequest, multipartFormData: MultipartFormData) throws(NetworkError) -> URLRequest {
        var urlRequest = try prepareURLRequestWithoutBody(using: httpRequest)
        
        urlRequest.httpMethod = httpRequest.httpMethod.rawValue
        urlRequest.addValue("multipart/form-data; boundary=\(multipartFormData.boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = multipartFormData.postBody
        
        return urlRequest
    }
    
    private func prepareURLRequestWithoutBody(using request: HTTPRequest) throws(NetworkError) -> URLRequest {
        var url = request.baseURL
        
        
        // Endpoint can contains queryParams if uri is supplied from outside.
        // So, we need to separate those path and query params.
        // The method `appending(path:, directoryHint: _)` is percent encoding our "?" present in endpoint.
        let endpoint = request.endPoint
        let urlComponents = URLComponents(string: endpoint)
        let uriQueryItems = urlComponents?.queryItems
        
        let path = urlComponents?.path ?? ""
        
        if #available(iOS 16.0, macOS 13, *)  {
            url = url.appending(path: path, directoryHint: .notDirectory)
        } else {
            // Fallback on earlier versions
            url = url.appendingPathComponent(path, isDirectory: false)
        }

        guard var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw .invalidURL
        }

        urlComponent.queryItems = uriQueryItems + request.queryParams
        
        guard let url = urlComponent.url else {
            throw .invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue

        urlRequest.allHTTPHeaderFields =  request.headers
        
        return urlRequest
    }
}
