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
    
    /// Use this method to add a dicrete type or unknown type data as form data.
       ///
       /// This method can be used to add JSON, image, video and font data etc. Must specify the exact mimeType (ContentType for JSON) for correctly recognize the data.
       ///
       /// Use `application/octet-stream` if the true type of data is unknown.
       ///
       /// - Parameters:
       ///   - name: The field name.
       ///   - fileName: The name of the file.
       ///   - mimeType: The MIME type of the file.
       ///   - data: The data to add.
    public mutating func addField(name: String, fileName: String? = nil, mimeType: String, data: Data) {
        formData.addField("--\(boundary)")
        var field = "\(contentDispositionFormData) name=\"\(name)\";"
        if let fileName {
            field.append(" filename=\"\(fileName)\"")
        }
        formData.addField(field)
        formData.addField("Content-Type: \(mimeType)")
        formData.addNewLine()
        formData.addField(data)
    }
}
