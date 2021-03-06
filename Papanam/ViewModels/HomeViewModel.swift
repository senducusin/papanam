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

enum AnnotationType: String {
    case pickup = "pickup"
    case destination = "destination"
}

class HomeViewModel {
    
    let homeView: UIView
    let locationInputViewHeight:CGFloat = 200
    let animationDuration:Double = 0.3
    
    var user: User? = nil {
        didSet {
            guard let user = user else {return}
            userDidSet?(user)
        }
    }
    
    var oldUser: User? = nil
    
    var userDidSet: ((_ user:User)->())?
    var route: MKRoute? = nil
    var trip: Trip? = nil
    var searchResults = [MKPlacemark]()
    var alreadySetupUI = false
    var actionButtonConfig = ActionButtonConfiguration()
    var appStarted = false
    var savedLocations = [MKPlacemark]()
    
    init(homeView:UIView){
        self.homeView = homeView
    }
    
    func shouldSetupUI() -> Bool {
        
        if !alreadySetupUI{
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
    
    var needsToReconfigure:Bool {
        let value = oldUser?.uid != user?.uid
        
        if value {
            oldUser = user
        }
        
        return value
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
    
    public func searchResultPlacemarkAt(index:Int) -> MKPlacemark {
        return searchResults[index]
    }
    
    var numberOfRowsForSavedLocations:Int{
        print("DEBUG: savedLocations \(savedLocations)")
        return savedLocations.count
    }
    
    public func savedLocationPlacemarkAt(index:Int) -> MKPlacemark {
        return savedLocations[index]
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

