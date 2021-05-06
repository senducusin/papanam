//
//  Trip.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/5/21.
//

import CoreLocation

struct Trip: Codable {
    var passengerUid: String? = nil
    var driverUid:String? = nil
    var state: TripState = .requested
    var destination: Place
    var pickup: Place
}

extension Trip {
    init?(passengerUid: String, dictionary:jsonDictionary){
        self.passengerUid = passengerUid
        
        guard let pickupPlaceDictionary = dictionary["pickup"] as? jsonDictionary,
              let pickup = Place(pickupPlaceDictionary)
              else {return nil}
        
        self.pickup = pickup
        
        guard let destinationPlaceDictionary = dictionary["destination"] as? jsonDictionary,
              let destination = Place(destinationPlaceDictionary) else {return nil}
        
        self.destination = destination
        
        self.driverUid = dictionary["driverUid"] as? String
        self.passengerUid = dictionary["passengerUid"] as? String

        guard let state = dictionary["state"] as? Int,
              let tripState = TripState(rawValue: state) else {return nil}
        self.state = tripState
    }
}


enum TripState: Int,Codable {
    case requested, accepted, inProgress, completed
}
