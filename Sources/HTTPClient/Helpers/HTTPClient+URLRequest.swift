//
//  HTTPClient+URLRequest.swift
//  HTTPClient
//
//  Created by Arun on 30/01/25.
//

import Foundation

extension HTTPClient {
    
    func prepareURLRequest(from request: HTTPRequest) throws(NetworkError) -> URLRequest {
        
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
                var encoder = request.encoder ?? JSONEncoder()
                urlRequest.httpBody = try encoder.encode(body)
            }
            return urlRequest
        }
        catch {
            throw .bodyEncodingError(description: error.localizedDescription)
        }
    }
    
    func prepareMultiPartURLRequest(httpRequest: HTTPRequest, multipartFormData: MultipartFormData) throws(NetworkError) -> URLRequest {
        let completeURL: URL?

        if #available(iOS 16.0, macOS 13, *)  {
            var url = httpRequest.baseURL.appending(path: httpRequest.endPoint)
            if let queryParams = httpRequest.queryParams {
                url = url.appending(queryItems: queryParams)
            }
            completeURL = url
        } else {
            let url = httpRequest.baseURL.appendingPathComponent(httpRequest.endPoint, isDirectory: false)
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = httpRequest.queryParams
            completeURL = urlComponents?.url
        }
        
        guard let completeURL else {
            throw .badURL
        }
        
        var urlRequest = URLRequest(url: completeURL)
        urlRequest.httpMethod = httpRequest.httpMethod.rawValue
        urlRequest.addValue("multipart/form-data; boundary=\(multipartFormData.boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = multipartFormData.postBody
        
        return urlRequest
    }
}
