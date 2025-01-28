//
//  File.swift
//  HTTPClient
//
//  Created by Arun on 28/01/25.
//

import Foundation

struct MultipartAPIResponse: Decodable {
    
    let originalname: String
    let filename: String
    let location: String
}
