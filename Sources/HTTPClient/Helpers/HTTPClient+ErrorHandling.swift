//
//  HTTPClient+ErrorHandling.swift
//  HTTPClient
//
//  Created by Avii 🔥 on 26/10/25.
//

import Foundation

// MARK: - Error Handling
extension HTTPClient {
    
    func checkStatusCode(_ response: URLResponse, _ data: Data) throws(NetworkError)  {
        
        if let response = response as? HTTPURLResponse {
            
            if 200...299 ~= response.statusCode {
                return
            }
            
            switch response.statusCode {
            case 400:
                throw NetworkError.badRequest(data: data)
            case 401:
                throw NetworkError.unauthorized
            default: break
            }
            
            throw .statusCode(code: response.statusCode, data: data)
        }
    }
    
    func handleDecodingError(_ decodingError: DecodingError) -> NetworkError {
        
        let errorString: String
        
        switch decodingError {
        case .typeMismatch(let type, let context):
            errorString = "Type mismatch for type \(type): \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            errorString = "Value not found for type \(type): \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            errorString = "Key not found: \(key.stringValue) in \(context.debugDescription)"
        case .dataCorrupted(let context):
            errorString = "Data corrupted: \(context.debugDescription)"
        @unknown default:
            errorString = "Unknown decoding error occurred."
        }
        
        return NetworkError.responseDecodingError(description: errorString)
    }
    
    // Custom error handling
    func handleURLError(_ urlError: URLError) -> NetworkError {
        
        switch urlError.code {
        case .notConnectedToInternet:
            return .noInternet
        case .timedOut:
            return .timeout
        case .cannotFindHost, .cannotConnectToHost:
            return .serverUnreachable
        case .cancelled:
            return .cancelled
        default: break
        }
        return .unknownError(error: urlError)
    }
}
