//
//  PickupViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import UIKit
import MapKit

struct PickupViewModel {
    let trip: Trip
    
    var pickupCoordinates: CLLocationCoordinate2D {
        return trip.pickupCoordinates
    }
    
    var destinationCoordinates: CLLocationCoordinate2D {
        return trip.destinationCoordinates
    }
    
    var address: String? {
        return trip.address
    }
    
    var title: String? {
        return trip.title
    }
    
    var latLongDistance: CLLocationDistance {
        return 1000
    }
    
    var region: MKCoordinateRegion {
        print("DEBUG: \(pickupCoordinates)")
        return MKCoordinateRegion(center: pickupCoordinates, latitudinalMeters: latLongDistance, longitudinalMeters: latLongDistance)
    }
    
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: pickupCoordinates)
    }
    
    var placeAnnotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pickupCoordinates
        return annotation
    }
}

