//
//  DriverService.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/10/21.
//

import Foundation
import CoreLocation
import Firebase
import GeoFire

class DriverService {
    static let shared = DriverService()
}

extension DriverService {
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
            removeAllObservers(uid: passengerUid)
        }
    }
    
    public func removeAllObservers(uid:String){
        Database.refTrips.child(uid).removeAllObservers()
    }
}
