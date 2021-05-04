//
//  LocationService.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/4/21.
//

import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    
    var locationManager: CLLocationManager!
    
    override init(){
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    private func setupLocationManager(){
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - Location Service Delegate & Helpers
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setupLocationManager()
        }
    }
}

// MARK: - Public Properties and Methods
extension LocationService {
    
    var location: CLLocation? {
        return locationManager.location
    }

    
    public func enableLocationServices(){
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
