//
//  FormButton.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class FormButton: UIButton {
    // MARK: - Properties
    var title: String? = nil {
        didSet {
            setTitle(title, for: .normal)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    // MARK: - Lifecycles
    override init(frame: CGRect){
        super.init(frame: frame)
        setTitle(title, for: .normal)
        setTitleColor(.themeWhiteText, for: .normal)
        backgroundColor = .themeBlue
        layer.cornerRadius = 5
        setHeight(height: 50)
        titleLabel?.font = .boldSystemFont(ofSize: 18)
        isEnabled = false
        setTitleColor(UIColor(white: 1, alpha: 0.37), for: .disabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
