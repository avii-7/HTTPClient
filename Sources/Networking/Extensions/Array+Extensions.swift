//
//  Array+Extensiona.swift
//  HTTPClient
//
//  Created by Avii 🔥  on 26/10/25.
//

import Foundation

extension Optional {
    static func + (lhs: Self, rhs: Self) -> Self {
        
        if let lhs {
            
            if let rhs {
                return lhs + rhs
            }
            
            return lhs
        }
        else if let rhs {
            if let lhs {
                return lhs + rhs
            }
            
            return rhs
        }
        
        return nil
    }
}
