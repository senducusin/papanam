//
//  CLPlacemark+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import MapKit
extension CLPlacemark {
    @objc var address: String? {
        get {
            let subThoroughfare = normalizeStringAddress(text: subThoroughfare)
            let thoroughfare = normalizeStringAddress(text: thoroughfare,withComma: true)
            let locality = normalizeStringAddress(text: locality,withComma: true)
            let adminArea = normalizeStringAddress(text: administrativeArea)
            
            return "\(subThoroughfare)\(thoroughfare)\(locality)\(adminArea)"
        }
    }
    
    private func normalizeStringAddress(text:String?, withComma:Bool = false) ->String{
        return text == nil ? "" : "\(text ?? "")\(withComma ? ",":"") "
    }
}
