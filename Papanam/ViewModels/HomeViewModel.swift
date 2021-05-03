//
//  HomeViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import Foundation

struct HomeViewModel {
    var alreadySetupUI = false
    
    mutating func shouldSetupUI() -> Bool {
        
        if !alreadySetupUI && AuthService.isUserLoggedIn() {
            self.alreadySetupUI.toggle()
            return true
        }
        
        return false
    }

}
