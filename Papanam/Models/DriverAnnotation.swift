//
//  DriverAnnotation.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/4/21.
//

import Foundation
import MapKit

class DriverAnnotation: NSObject, MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid:String, coordinate: CLLocationCoordinate2D){
        self.uid = uid
        self.coordinate = coordinate
    }
    
    private func isNewCoordinate(_ coordinate:CLLocationCoordinate2D) -> Bool{
        if self.coordinate.latitude == coordinate.latitude &&
            self.coordinate.longitude == coordinate.longitude {
           
            return false
        }
        
        return true
    }

}

extension DriverAnnotation {
    public func updateAnnotationPosition(withCoordinate coordinate: CLLocationCoordinate2D){
        
        if !isNewCoordinate(coordinate){
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}
