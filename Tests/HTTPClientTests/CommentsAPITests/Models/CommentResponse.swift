//
//  CommentResponse.swift
//  HTTPClient
//
//  Created by Arun on 18/01/25.
//

import XCTest

struct CommentsResponse: Decodable {
    let comments: [Comment]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Comment: Decodable {
    let id: Int
    let body: String
    let postId: Int
    var likes: Int = 0
    let user: User
    
    struct User: Codable {
        let id: Int
        let username: String
        let fullName: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id, body, postId, likes, user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        body = try container.decode(String.self, forKey: .body)
        postId = try container.decode(Int.self, forKey: .postId)
        likes = try container.decodeIfPresent(Int.self, forKey: .likes) ?? 0
        user = try container.decode(User.self, forKey: .user)
    }
}

extension Comment {
    
}
