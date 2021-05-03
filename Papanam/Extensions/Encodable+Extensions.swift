//
//  Encodable+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation

typealias jsonDictionary = [String: Any]

extension Encodable {
    func toDictionary() -> jsonDictionary? {
        if let data = try? JSONEncoder().encode(self) {
            if let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                return dictionary
            }
        }
        
        return nil
    }
}
