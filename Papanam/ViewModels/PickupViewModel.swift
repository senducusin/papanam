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
        return trip.pickup.coordinate
    }
    
    var destinationCoordinates: CLLocationCoordinate2D {
        return trip.destination.coordinate
    }
    
    var dropoffAddress: String? {
        guard let address = trip.destination.address else {return nil}
        return address
    }
    
    var pickupAddress: String? {
        guard let address = trip.pickup.address else {return nil}
        return address
    }
    
    var latLongDistance: CLLocationDistance {
        return 1000
    }
    
    var region: MKCoordinateRegion {
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
    
    var distance: String {
        let pickupLocation = CLLocation(latitude: pickupCoordinates.latitude, longitude: pickupCoordinates.longitude)
        
        let dropoffLocation = CLLocation(latitude: destinationCoordinates.latitude, longitude: destinationCoordinates.longitude)
        
        return "\(String(format: "%.1f", pickupLocation.distance(from: dropoffLocation) / 1609.344) ) mi"
    }
    
    public func getEta(completion:@escaping(String?)->()){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinates))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else {
                completion(nil)
                return
            }
            
            if response.routes.count > 0 {
                let route = response.routes[0]
                completion( "\(String(format: "%.1f", route.expectedTravelTime/60)) min" )
            }
        }
    }
}

