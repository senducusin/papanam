//
//  HomeViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit
import MapKit

enum ActionButtonConfiguration {
    case showMenu
    case dismissActionView
    
    init(){
        self = .showMenu
    }
    
    var buttonImage: UIImage? {
        switch self {
        case .showMenu:
            return UIImage.menuImage
        case .dismissActionView:
            return UIImage.backImage
        }
    }
}

struct HomeViewModel {
    
    let homeView: UIView
    let locationInputViewHeight:CGFloat = 200
//    let rideActionViewHeight:CGFloat = 300
    let animationDuration:Double = 0.3
    
    var user: User? = nil
    var route: MKRoute? = nil
    var searchResults = [MKPlacemark]()
    var alreadySetupUI = false
    var actionButtonConfig = ActionButtonConfiguration()
    
    mutating func shouldSetupUI() -> Bool {
        
        if !alreadySetupUI && AuthService.shared.isUserLoggedIn() {
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

// MARK: - RideActionView
extension HomeViewModel {
    var rideActionViewStartingOriginY: CGFloat {
        return homeView.frame.height
    }
    
    var rideActionViewWidth: CGFloat {
        return homeView.frame.width
    }
    
    var rideActionViewHeight:CGFloat {
        return 300
    }
    
    public func getRideActionViewOriginY(present:Bool) -> CGFloat{
        let height = present ? rideActionViewHeight : 0
        return homeView.frame.height - height
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
    
    var numberOfRowsForSearchResult: Int {
        return searchResults.count
    }
    
    public func placemarkAt(index:Int) -> MKPlacemark {
        return searchResults[index]
    }
}

// MARK: MapView
extension HomeViewModel {
    public func driverIsVisible(mapView: MKMapView, user:User) -> DriverAnnotation?{
        var driverAnnotation: DriverAnnotation? = nil
        
        var isVisible:Bool {
            return mapView.annotations.contains { annotation in
                guard let driverAnno = annotation as? DriverAnnotation else {return false}
                
                if driverAnno.uid == user.uid {
                    driverAnnotation = driverAnno
                    return true
                }
                return false
            }
        }
        
        if !isVisible {
            return nil
        }
        
        return driverAnnotation
    }
}

