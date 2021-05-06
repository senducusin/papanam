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
