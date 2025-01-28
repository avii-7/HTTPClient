//
//  Data+Extensions.swift
//  HTTPClient
//
//  Created by Arun on 27/01/25.
//

import Foundation

/// Reference: https://gist.github.com/msanford1540/e8b6e5e85dd4a79c3f4867ec472fc1c9
extension Data {
    
    private mutating func append(_ string: String) {
        append(Data(string.utf8))
    }
    
    mutating func addField(_ data: Data) {
        append(data)
        addNewLine()
    }
    
    mutating func addField(_ string: String) {
        append(string)
        addNewLine()
    }
    
    mutating func addNewLine() {
        append(.httpFieldDelimiter)
    }
}
