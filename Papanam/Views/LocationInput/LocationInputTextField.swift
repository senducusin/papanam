//
//  LocationInputTextField.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/3/21.
//

import UIKit
class LocationInputTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        font = .systemFont(ofSize: 14)
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        leftView = paddingView
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
