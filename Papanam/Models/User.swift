//
//  User.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation

struct User{
    let email: String
    let fullname: String
    let userType: UserType
}

extension User {
    init?(_ dictionary: jsonDictionary){
        guard let email = dictionary["email"] as? String,
              let fullname = dictionary["fullname"] as? String,
              let userTypeInt = dictionary["userType"] as? Int,
              let userType = UserType(rawValue: userTypeInt) else {
            return nil
        }
        self.email = email
        self.fullname = fullname
        self.userType = userType
    }
}
