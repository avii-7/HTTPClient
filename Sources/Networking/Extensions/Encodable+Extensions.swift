//
//  File.swift
//  HTTPClient
//
//  Created by Arun on 26/01/25.
//

import Foundation

extension Encodable {
    
    func toDictionary() -> [String: Any]? {
        do {
            let json = try JSONEncoder().encode(self)
            let result = try JSONSerialization.jsonObject(with: json) as? [String: Any]
            return result
        }
        catch {
            print("Falied to convert encodable instance to Dictionary: \(error)")
            return nil
        }
    }
}
