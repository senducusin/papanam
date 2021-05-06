//
//  AuthService.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation
import Firebase
import GeoFire

typealias errorCompletion = ((Error?) -> ())
typealias userOrErrorCompletion = ((Result<User,AuthServiceError>)->())

enum AuthServiceError: Error {
    case passwordIsEmpty
    case encodingError
    case uidNotFound
    case userNotFound
    case locationNotFound
}

class AuthService {
    
    static let shared = AuthService()
}

extension AuthService {
    // MARK: - Create New User
    public func signupNewUser(_ newUser: NewUser, completion:@escaping errorCompletion){
        
        let ref = Database.refDriverLocations
        
        guard let password = newUser.password,
              let location = LocationService.shared.location else {
            
            if LocationService.shared.location == nil {
                completion(AuthServiceError.locationNotFound)
            }else{
                completion(AuthServiceError.passwordIsEmpty)
            }
            
            return
        }
        
        Auth.auth().createUser(withEmail: newUser.email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            // to clean password
            let newUser = NewUser(newUser)
            
            guard let newUserDictionary = newUser.toDictionary() else {
                completion(AuthServiceError.encodingError)
                return
            }
            
            guard let uid = result?.user.uid else {
                completion(AuthServiceError.uidNotFound)
                return
            }
            
            if newUser.type == .driver {
                let geoFire = GeoFire(firebaseRef: ref)
                geoFire.setLocation(location, forKey: uid) { error in
                    Database.refUsers.child(uid).updateChildValues(newUserDictionary)
                    completion(nil)
                }
            }else{
                Database.refUsers.child(uid).updateChildValues(newUserDictionary)
                completion(nil)
            }
        }
    }
    
    // MARK: - Login
    public func loginUserWith(email:String, password:String, completion:@escaping errorCompletion){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    // MARK: - Logout
    public func signOut(completion:@escaping errorCompletion){
        print("DEBUG: Signing out...")
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch{
            completion(error)
        }
        
    }
    
    // MARK: - isLoggedIn
    var activeUser: String? {
        
        guard let uid = Auth.auth().currentUser?.uid else {return nil}
        
        return uid
    }
}
