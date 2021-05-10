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
    
    let view :UIView
    
    init(view:UIView){
        self.view = view
    }
    
    public mutating func frameOrigin() ->CGFloat {
        
        if !toggled {
            toggled.toggle()
        }
        
        _showMenu.toggle()
        
        return _showMenu ? view.frame.width - 80 : 0
    }

    
}
