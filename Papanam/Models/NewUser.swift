//
//  NewUser.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation

enum UserType:Int, Encodable {
    case rider
    case driver
}

struct NewUser:Encodable{
    let email: String
    let fullname: String
    let userType: UserType
    
    var password: String?
}

extension NewUser {
    init(_ newUser: NewUser){
        self.email = newUser.email
        self.fullname = newUser.fullname
        self.userType = newUser.userType
        self.password = nil
    }
}
