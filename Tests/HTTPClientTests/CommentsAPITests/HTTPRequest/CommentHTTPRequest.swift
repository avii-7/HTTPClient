//
//  CommentHTTPRequest.swift
//  HTTPClient
//
//  Created by Arun on 18/01/25.
//

import Foundation
@testable import HTTPClient

enum CommentHTTPRequest: HTTPRequest {
    
    case all, add(body: CommentAddBody), delete(commnetId: Int)
    
    var endPoint: String {
        switch self {
        case .all: "comments"
        case .add: "comments/add"
        case .delete(let commentId): "comments/\(commentId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .all: .get
        case .add: .post
        case .delete: .delete
        }
    }
    
    var body: Encodable? {
        if case .add(let body) = self {
            return body
        }
        return nil
    }

    var baseURL: URL {
        URL(string: "https://dummyjson.com/")!
    }
}
