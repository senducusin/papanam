//
//  DriverAnnotation.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/4/21.
//

import Foundation
import MapKit

class DriverAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid:String, coordinate: CLLocationCoordinate2D){
        self.uid = uid
        self.coordinate = coordinate
    }
}
