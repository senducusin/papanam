//
//  CLLocationCoordinate2D+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import CoreLocation

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
