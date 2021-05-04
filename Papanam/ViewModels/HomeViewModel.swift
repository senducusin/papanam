//
//  HomeViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit

struct HomeViewModel {
    
    let homeView: UIView
    var user: User? = nil
    let locationInputViewHeight:CGFloat = 200
    let animationDuration:Double = 0.3
    
    var alreadySetupUI = false

    mutating func shouldSetupUI() -> Bool {
        
        if !alreadySetupUI && AuthService.shared.isUserLoggedIn() {
            print("DEBUG: user found!")
            self.alreadySetupUI.toggle()
            return true
        }
        
        return false
    }
}

// MARK: - InputActivationView
extension HomeViewModel {
    var inputActivationViewWidth: CGFloat {
        return homeView.frame.width - 64
    }
}

// MARK: - TableView
extension HomeViewModel {
    var tableViewStartingOriginY: CGFloat {
        return homeView.frame.height
    }
    
    var tableViewWidth: CGFloat {
        return homeView.frame.width
    }
    
    var tableViewHeight: CGFloat {
        return homeView.frame.height - locationInputViewHeight
    }
}

