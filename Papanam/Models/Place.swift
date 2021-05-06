//
//  Place.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import CoreLocation

struct Place:Codable {
    let coordinate: CLLocationCoordinate2D
    let address:String?
    let name:String?
}

extension Place{
    init?(_ dictionary: jsonDictionary){
        guard let coordinate = dictionary["coordinate"] as? NSArray,
              let lat = coordinate[0] as? CLLocationDegrees,
              let lon = coordinate[1] as? CLLocationDegrees else {return nil}
        
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.address = dictionary["address"] as? String
        self.name = dictionary["name"] as? String
    }
}
