//
//  RideActionViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/7/21.
//

import Foundation
import MapKit

enum RideActionConfiguration: Int{
    case requestRide, tripAccepted, pickupPassenger, tripInProgress, endTrip, driverArrived
}

struct RideActionViewModel{
    
    var driver: User?
    var passenger: User?
    var currentUserType: UserType!
    
    var config: RideActionConfiguration {
        didSet {
            setConfig?(self)
        }
    }
    
    var placemark: MKPlacemark? = nil {
        didSet {
            guard self.placemark != nil else {return}
            setConfig?(self)
        }
    }
    
    var setConfig: ((RideActionViewModel)->())? = nil
    
    var buttonDescription: String {
        
        switch config {
        
        case .requestRide:
            return "CONFIRM DESTINATION"
        case .tripAccepted, .driverArrived:
            return currentUserType == .driver ? "GET DIRECTIONS" : "CANCEL RIDE"
        case .pickupPassenger:
            return "PICKUP PASSENGER"
        case .tripInProgress:
            return currentUserType == .passenger ? "TRIP IN PROGRESS" : "GET DIRECTIONS"
        case .endTrip:
            return currentUserType == .driver ? "DROP OFF PASSENGER" : "ARRIVED AT DESTINATION"
        }
    }
    
    var nameText: String? {
        
        
        switch config {
        
        case .requestRide:
            return placemark?.name
        case .tripAccepted:
            return currentUserType == .driver ? "En Route To Passenger" : "Driver En Route"
        case .pickupPassenger:
            return "Arrived at passenger's location"
        case .driverArrived:
            if currentUserType == .passenger {
                return "Driver has Arrived"
            }
            return ""
            
        case .tripInProgress:
            return "En Route to Destination"
            
        case .endTrip:
            return "Arrived at Destination"
            
        default:
            return ""
        }
    }
    
    var addressText: String? {
        switch config {
        
        case .requestRide:
            return placemark?.address
        case .driverArrived:
            return "Please meet driver at pickup point"
            
        default:
            return ""
        }
    }
    
    var titleText:String {
        
        switch config {
        
        case .requestRide:
            return "PAPANAM"
            
   
            
        default:
            if currentUserType == .driver {
                guard let passenger = passenger else {return "Passenger"}
                return passenger.fullname
            }else {
                guard let driver = driver else {return "Driver"}
                return driver.fullname
            }
        }
    }
    
    var infoLabelCharacter: String? {
        if currentUserType == .driver {
            guard let passenger = passenger,
                  let first = passenger.fullname.first else {return "P"}
            return String(first)
        }else if currentUserType == .passenger {
            guard let driver = driver,
                  let first = driver.fullname.first else {return "D"}
            return String(first)
        }
        return nil
    }
    
    var buttonShouldEnable:Bool {
        if config == .tripInProgress && currentUserType == .passenger ||
            config == .endTrip && currentUserType == .passenger {
            return false
        }
        return true
    }
    
}
