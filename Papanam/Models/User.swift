//
//  User.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation
import CoreLocation

enum UserType:Int, Encodable {
    case passenger
    case driver
}

struct User{
    let uid: String
    let email: String
    let fullname: String
    let type: UserType
    var homeLocation: String?
    var workLocation: String?
    var location: CLLocation? = nil
}

extension User {
    init?(_ uid:String, withDictionary dictionary: jsonDictionary){
        guard let email = dictionary["email"] as? String,
              let fullname = dictionary["fullname"] as? String,
              let typeInt = dictionary["type"] as? Int,
              let type = UserType(rawValue: typeInt) else {
            return nil
        }
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.type = type
        
        self.homeLocation = dictionary["homeLocation"] as? String
        self.workLocation = dictionary["workLocation"] as? String
    }
}
