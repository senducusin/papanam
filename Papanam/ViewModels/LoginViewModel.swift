//
//  LoginViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation

struct LoginViewModel {
    var email: String? = nil
    var password: String? = nil
    
    var formIsValid: Bool {
        guard let email = email,
              !email.isEmpty,
              let password = password,
              !password.isEmpty else {
            return false
        }
        return true
    }
    
    mutating func clearForm(){
        email = nil
        password = nil
    }
}
