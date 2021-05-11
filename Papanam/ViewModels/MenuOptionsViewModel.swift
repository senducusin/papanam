//
//  MenuOptionsViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/11/21.
//

import Foundation

enum MenuOptionsViewModel: Int, CaseIterable {
    case yourTrips, settings, logout
    
    var description: String {
        switch self{
        case .yourTrips:
            return "Your Trips"
        case .settings:
            return "Settings"
        case .logout:
            return "Log Out"
        }
    }
    
    
}
