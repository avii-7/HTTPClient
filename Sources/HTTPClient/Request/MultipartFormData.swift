//
//  MultipartFormData.swift
//  HTTPClient
//
//  Created by Arun on 26/01/25.
//

import Foundation

public struct MultipartFormData {
    
    public let boundary = UUID().uuidString
    
    private var formData = Data()
    
    private let contentDispositionFormData = "Content-Disposition: form-data;"
    
    var postBody: Data {
        var postBody = formData
        postBody.addField("--\(boundary)--")
        return postBody
    }
   
    /// for key value data
    public mutating func addField(name: String, value: String) {
        formData.addField("--\(boundary)")
        formData.addField("\(contentDispositionFormData) name=\"\(name)\"")
        formData.addNewLine()
        formData.addField(value)
    }
    
    /// For file upload
    public mutating func addField(name: String, fileName: String, contentType: String, data: Data) {
        formData.addField("--\(boundary)")
        formData.addField("\(contentDispositionFormData) name=\"\(name)\"; filename=\"\(fileName)\"")
        formData.addField("Content-Type: \(contentType)")
        formData.addNewLine()
        formData.addField(data)
    }
    
    /// For JSON
    public mutating func addField(name: String, encodableData: Encodable, jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        formData.addField("--\(boundary)")
        formData.addField("\(contentDispositionFormData) name=\"\(name)\"")
        formData.addField("Content-Type: application/json")
        formData.addNewLine()
        
        let data = try jsonEncoder.encode(encodableData)
        formData.addField(data)
    }
}
