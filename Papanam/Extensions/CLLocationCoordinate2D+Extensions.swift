//
//  CLLocationCoordinate2D+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import MapKit

extension CLLocationCoordinate2D: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        try container.encode(latitude)
        try container.encode(longitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.init()
        
        latitude = try container.decode(Double.self)
        longitude = try container.decode(Double.self)
    }
}

extension CLLocationCoordinate2D {
    func getAddress(completion:@escaping (Place?)->()) {
        
        let location: CLLocation = CLLocation(latitude:self.latitude, longitude: self.longitude)
        
    
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            guard let placemarks = placemarks,
                  placemarks.count > 0,
                  error == nil
            else {
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                }
                return
            }
            
            let placemark = placemarks[0]
            
            completion(Place(coordinate: self, address: placemark.address, name: placemark.name))

        }
    }
}
