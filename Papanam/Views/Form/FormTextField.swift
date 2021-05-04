//
//  FormTextField.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class FormTextField: UITextField {
    init(placeholder: String, isSecured: Bool = false) {
        super.init(frame: .zero)
        
        borderStyle = .none
        font = .systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        isSecureTextEntry = isSecured
        attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        isEnabled = true
        autocorrectionType = .no
        autocapitalizationType = .none
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
