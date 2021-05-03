//
//  Encodable+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        if let data = try? JSONEncoder().encode(self) {
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                return dictionary
            }
        }
        
        return nil
    }
}
