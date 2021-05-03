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
    case uidNotFound
}

class AuthService {
    static let dbUserReference = Database.database().reference().child("users")
    
    
    // MARK: - Create New User
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
            
            guard let uid = result?.user.uid else {
                completion(AuthServiceError.uidNotFound)
                return
            }
            
            dbUserReference.child(uid).updateChildValues(newUserDictionary)
            completion(nil)
        }
    }
    
    
    // MARK: - Login
    static func loginUserWith(email:String, password:String, completion:@escaping errorCompletion){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    // MARK: - Logout
    static func signOut(completion:@escaping errorCompletion){
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch{
            completion(error)
        }
        
    }
    
    // MARK: - isLoggedIn
    static func isUserLoggedIn() -> Bool {
        if Auth.auth().currentUser?.uid == nil {
            return false
        }
        
        return true
    }
}
