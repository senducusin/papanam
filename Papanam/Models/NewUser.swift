//
//  NewUser.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation


struct NewUser:Encodable{
    let email: String
    let fullname: String
    let type: UserType
    
    var password: String?
}

extension NewUser {
    init(_ newUser: NewUser){
        self.email = newUser.email
        self.fullname = newUser.fullname
        self.type = newUser.type
        self.password = nil
    }
}
