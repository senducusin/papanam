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
    private let dbRef = Database.database().reference()
    private let dbUserRef = Database.database().reference().child("users")
    private let dbDriverLocationRef = Database.database().reference().child("driver-locations")
    
}

extension AuthService {
    // MARK: - Create New User
    public func signupNewUser(_ newUser: NewUser, completion:@escaping errorCompletion){
        
        let ref = self.dbDriverLocationRef
        
        guard let password = newUser.password,
              let location = LocationService.shared.location else {
            
            if LocationService.shared.location == nil {
                completion(AuthServiceError.locationNotFound)
            }else{
                completion(AuthServiceError.passwordIsEmpty)
            }
            
            return
        }
        
        Auth.auth().createUser(withEmail: newUser.email, password: password) { [weak self] result, error in
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
            
            if newUser.userType == .driver {
                let geoFire = GeoFire(firebaseRef: ref)
                geoFire.setLocation(location, forKey: uid) { error in
                    self?.dbUserRef.child(uid).updateChildValues(newUserDictionary)
                    completion(nil)
                }
            }else{
                self?.dbUserRef.child(uid).updateChildValues(newUserDictionary)
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
        do{
            try Auth.auth().signOut()
            completion(nil)
        }catch{
            completion(error)
        }
        
    }
    
    // MARK: - isLoggedIn
    public func isUserLoggedIn() -> Bool {
        
        guard Auth.auth().currentUser?.uid != nil else {return false}
        
        return true
    }
    
    // MARK: - Fetch User
    public func fetchUserDataWith(completion:@escaping userOrErrorCompletion){
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotFound))
            return
        }
        
        dbUserRef.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            if let userDictionary = snapshot.value as? jsonDictionary {
                guard let user = User(userDictionary) else {
                    completion(.failure(.userNotFound))
                    return
                }
                completion(.success(user))
            }else{
                completion(.failure(.userNotFound))
            }
        }
    }
}
