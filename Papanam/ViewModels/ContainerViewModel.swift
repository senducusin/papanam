//
//  ContainerViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/10/21.
//

import UIKit

struct ContainerViewModel {
    private var _showMenu = false
    private(set) var toggled = false
    private let viewWidth:CGFloat = 80
    var appStarted = false
    
    var user: User?
    
    let view :UIView
    
    init(view:UIView){
        self.view = view
    }
    
    public mutating func frameOrigin() ->CGFloat {
        
        if !toggled {
            toggled.toggle()
        }
        
        _showMenu.toggle()
        
        return _showMenu ? view.frame.width - viewWidth : 0
    }
    
    var showMenu:Bool {
        return _showMenu
    }

    var blackViewAlpha: CGFloat {
        return _showMenu ? 1.0 : 0.0
    }
    
    var blackViewFrame: CGRect {
        return _showMenu ? CGRect(x: view.frame.width - viewWidth, y: 0, width: viewWidth, height: view.frame.height) : .zero
    }
    
    var blackViewOriginX: CGFloat {
        return _showMenu ? view.frame.width - viewWidth : 0
    }
    
}
