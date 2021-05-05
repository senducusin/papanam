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
    let userType: UserType
    var location: CLLocation? = nil
}

extension User {
    init?(_ uid:String, withDictionary dictionary: jsonDictionary){
        guard let email = dictionary["email"] as? String,
              let fullname = dictionary["fullname"] as? String,
              let userTypeInt = dictionary["userType"] as? Int,
              let userType = UserType(rawValue: userTypeInt) else {
            return nil
        }
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.userType = userType
    }
}
