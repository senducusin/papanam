//
//  SettingsViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/12/21.
//

import Foundation

enum SettingsViewModel: Int, CaseIterable {
    case home, work
    
   
    
    var description: String {
        switch self {
        case .home:
            return "Home"
            
        case .work:
            return "Work"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home:
            return "Add Home"
            
        case .work:
            return "Add Work"
        }
    }
}
