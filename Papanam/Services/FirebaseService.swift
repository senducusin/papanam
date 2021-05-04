//
//  FirebaseService.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/4/21.
//

import Foundation
import CoreLocation
import Firebase
import GeoFire

class FirebaseService {
    static let shared = FirebaseService()
    
    private func fetchUserDataWith(uid:String, location:CLLocation? = nil, completion:@escaping userOrErrorCompletion){
        Database.refUsers.child(uid).observeSingleEvent(of: .value) { snapshot in
            if let userDictionary = snapshot.value as? jsonDictionary {
                guard var user = User(snapshot.key, withDictionary: userDictionary) else {
                    completion(.failure(.userNotFound))
                    return
                }
                
                if let location = location {
                    user.location = location
                }
                
                completion(.success(user))
            }else{
                completion(.failure(.userNotFound))
            }
        }
    }
}

extension FirebaseService {
    // MARK: - Fetch User
    public func fetchCurrentUserData(completion:@escaping userOrErrorCompletion){
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotFound))
            return
        }
        
        fetchUserDataWith(uid: uid, completion: completion)
    }
    
    // MARK: - Fetch Drivers
    public func fetchDrivers(completion:@escaping userOrErrorCompletion){
        guard let location = LocationService.shared.location else {return}
        let geoFire = GeoFire(firebaseRef: Database.refDriverLocations)
        
        Database.refDriverLocations.observe(.value) { [weak self] snapshot in
            
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered, with: { [weak self] uid, location in
                self?.fetchUserDataWith(uid: uid, location: location, completion: completion)
            })
        }
    }
}
