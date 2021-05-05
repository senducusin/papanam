//
//  Trip.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/5/21.
//

import CoreLocation

struct Trip {
    var pickupCoordinates: CLLocationCoordinate2D
    var destinationCoordinates: CLLocationCoordinate2D
    let passengerUid: String
    var driverUid:String? = nil
    var state: TripState
    

}

extension Trip {
    init?(passengerUid: String, dictionary:jsonDictionary){
        self.passengerUid = passengerUid
        
        guard let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray,
              let lat = pickupCoordinates[0] as? CLLocationDegrees,
              let lon = pickupCoordinates[1] as? CLLocationDegrees else {return nil}
        
        self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        guard let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray,
              let lat = destinationCoordinates[0] as? CLLocationDegrees,
              let lon = destinationCoordinates[1] as? CLLocationDegrees else {return nil}
        
        self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        guard let state = dictionary["state"] as? Int,
              let tripState = TripState(rawValue: state) else {return nil}
        self.state = tripState
        
    }
}


enum TripState: Int {
    case requested, accepted, inProgress, completed
}
