//
//  AuthService.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation
import Firebase

typealias errorCompletion = ((Error?) -> ())

enum AuthServiceError: Error {
    case passwordIsEmpty
    case encodingError
}

class AuthService {
    static let dbUserReference = Database.database().reference().child("users")
    
    static func signupNewUser(_ newUser: NewUser, completion:@escaping errorCompletion){
        guard let password = newUser.password else {
            completion(AuthServiceError.passwordIsEmpty)
            return
        }
        
        Auth.auth().createUser(withEmail: newUser.email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            // clean password
            let newUser = NewUser(newUser)
            
            guard let newUserDictionary = newUser.toDictionary() else {
                completion(AuthServiceError.encodingError)
                return
            }
            
            dbUserReference.updateChildValues(newUserDictionary)
            completion(nil)
        }
    }
}
