//
//  File.swift
//  HTTPClient
//
//  Created by Arun on 30/01/25.
//

import Foundation

extension HTTPClient {
    
    func handleResponse(_ response: URLResponse, data: Data, urlRequest: URLRequest) throws(NetworkError) {
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
