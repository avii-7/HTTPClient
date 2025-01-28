//
//  File.swift
//  HTTPClient
//
//  Created by Arun on 27/01/25.
//

import Foundation
@testable import HTTPClient

enum MultipartHTTPRequest: HTTPRequest {

    case uploadFile
    
    var endPoint: String { "/files/upload" }
    
    var httpMethod: HTTPMethod { .post }
    
    var baseURL: URL {
        URL(string: "https://api.escuelajs.co/api/v1")!
    }
}
