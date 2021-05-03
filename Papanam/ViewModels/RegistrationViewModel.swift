//
//  RegistrationViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation

struct RegistrationViewModel{
    var email:String? = nil
    var password:String? = nil
    var fullname:String? = nil
    
    var formIsValid:Bool {
        guard let email = email,
              !email.isEmpty,
              let password = password,
              !password.isEmpty,
              let fullname = fullname,
              !fullname.isEmpty else {
            return false
        }
        
        return true
    }
}
