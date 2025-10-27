//
//  CommentAddBody.swift
//  HTTPClient
//
//  Created by Arun on 18/01/25.
//

import Foundation

struct CommentAddBody: Encodable {
    let body: String
    let postId: Int
    let userId: Int
}
