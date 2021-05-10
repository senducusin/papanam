//
//  MenuViewModel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/10/21.
//

import UIKit

struct MenuViewModel{
    let view :UIView
    
    init(view:UIView){
        self.view = view
    }
    
    var frameWidth: CGFloat {
        return view.frame.width - 80
    }
    
    var headerFrameHeight: CGFloat {
        return 180
    }
}
