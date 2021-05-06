//
//  PickupLabel.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/6/21.
//

import UIKit

class PickupLabel: UILabel {
    init(){
        super.init(frame: .zero)
        textColor = UIColor(white: 1, alpha: 0.60)
        font = .systemFont(ofSize: 14)
        textAlignment = .center
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
