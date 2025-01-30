//
//  MultipartFormData.swift
//  HTTPClient
//
//  Created by Arun on 26/01/25.
//

import Foundation

/// A helper struct for constructing multipart form data requests.
public struct MultipartFormData {
    
    public let boundary = UUID().uuidString
    
    private var formData = Data()
    
    private let contentDispositionFormData = "Content-Disposition: form-data;"
    
    /// The complete multipart form data body to be used in the request.
    var postBody: Data {
        var postBody = formData
        postBody.addField("--\(boundary)--")
        return postBody
    }
   
    /// Adds a key-value pair as form data.
        ///
        /// - Parameters:
        ///   - name: The field name.
        ///   - value: The field value as a string.
    public mutating func addField(name: String, value: String) {
        formData.addField("--\(boundary)")
        formData.addField("\(contentDispositionFormData) name=\"\(name)\"")
        formData.addNewLine()
        formData.addField(value)
    }
    
    /// Adds a file field to the form data.
       ///
       /// - Parameters:
       ///   - name: The field name.
       ///   - fileName: The name of the file.
       ///   - contentType: The MIME type of the file.
       ///   - data: The file data.
    public mutating func addField(name: String, fileName: String, contentType: String, data: Data) {
        formData.addField("--\(boundary)")
        formData.addField("\(contentDispositionFormData) name=\"\(name)\"; filename=\"\(fileName)\"")
        formData.addField("Content-Type: \(contentType)")
        formData.addNewLine()
        formData.addField(data)
    }
    
    /// Adds a JSON-encoded object as form data.
        ///
        /// - Parameters:
        ///   - name: The field name.
        ///   - encodableData: The encodable object.
        ///   - jsonEncoder: The `JSONEncoder` to use (default is `JSONEncoder()`).
        /// - Throws: An error if encoding fails.
    public mutating func addField(name: String, encodableData: Encodable, jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        formData.addField("--\(boundary)")
        formData.addField("\(contentDispositionFormData) name=\"\(name)\"")
        formData.addField("Content-Type: application/json")
        formData.addNewLine()
        
        let data = try jsonEncoder.encode(encodableData)
        formData.addField(data)
    }
}
