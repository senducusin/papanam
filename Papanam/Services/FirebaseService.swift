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
    
    public func fetchUserDataWith(uid:String, location:CLLocation? = nil, completion:@escaping userOrErrorCompletion){
        Database.refUsers.child(uid).observeSingleEvent(of: .value) { snapshot in
            if let userDictionary = snapshot.value as? jsonDictionary {
                guard var user = User(snapshot.key, withDictionary: userDictionary) else {
                    completion(.failure(.encodingError))
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

// MARK: - Driver API
extension FirebaseService {
    public func observeAddedTrips(completion:@escaping(Trip?)->()) {
        Database.refTrips.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? jsonDictionary else {
                completion(nil)
                return
            }
            
            let trip = Trip(passengerUid: snapshot.key, dictionary: dictionary)
            completion(trip)
        }
    }
    
    public func observeCancelledTrip(_ trip: Trip, completion:@escaping()->()){
        guard let passengerUid = trip.passengerUid else {return}
        
        Database.refTrips.child(passengerUid).observeSingleEvent(of: .childRemoved) { snapshot in
            completion()
        }
       
    }
    
    public func acceptTrip(_ trip:Trip, completion:@escaping(Error?, DatabaseReference)->()){
        guard let uid = Auth.auth().currentUser?.uid,
              let tripUid = trip.passengerUid else {return}
        
        let values = [
            "driverUid":uid,
            "state":TripState.accepted.rawValue
        ] as [String : Any]
        
        Database.refTrips.child(tripUid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    public func updateDriverLocation(location:CLLocation){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let geofire = GeoFire(firebaseRef: Database.refDriverLocations)
        geofire.setLocation(location, forKey: uid)
    }
    
    public func updateTripState(trip: Trip, state: TripState, completion:@escaping(Error?, DatabaseReference)->()){
        guard let passengerUid = trip.passengerUid else { return }
        
        Database.refTrips.child(passengerUid).child("state").setValue(state.rawValue, withCompletionBlock: completion)
        
        if state == .completed {
            guard let passengerUid = trip.passengerUid else {return}
            Database.refTrips.child(passengerUid).removeAllObservers()
        }
    }
}

// MARK: - Passenger API
extension FirebaseService {
    public func uploadTrip(_ trip: Trip, completion:@escaping(Error?, DatabaseReference)->()){
        
        guard let uid = Auth.auth().currentUser?.uid,
              let dictionary = trip.toDictionary() else {
            print("DEBUG: error encoding")
            return
        }
        
        Database.refTrips.child(uid).updateChildValues(dictionary,withCompletionBlock: completion)
    }
    
    public func fetchDrivers(completion:@escaping userOrErrorCompletion){
        guard let location = LocationService.shared.location else {return}
        let geoFire = GeoFire(firebaseRef: Database.refDriverLocations)
        
        Database.refDriverLocations.observe(.value) { [weak self] snapshot in
            
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered, with: { [weak self] uid, location in
                self?.fetchUserDataWith(uid: uid, location: location, completion: completion)
            })
        }
    }
    
    public func observeCurrentTrip(completion:@escaping(Trip?)->()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.refTrips.child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? jsonDictionary else {
                completion(nil)
                return
            }
            let trip = Trip(passengerUid: snapshot.key, dictionary: dictionary)
            completion(trip)
        }
    }
    
    public func deleteTrip(completion:@escaping(Error?,DatabaseReference) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.refTrips.child(uid).removeValue(completionBlock: completion)
    }

}
