//
//  FormTextFieldContainer.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class FormTextFieldContainer: UIView {
    init(formTextField: FormTextField, icon: UIImage?){
        super.init(frame: .zero)
        
        let imageView = UIImageView()
        imageView.image = icon
        imageView.alpha = 0.87
        imageView.tintColor = .white
        
        addSubview(imageView)
        imageView.centerY(inView: self)
        imageView.anchor(left: leftAnchor, width: 25, height: 20)
        
        addSubview(formTextField)
        formTextField.centerY(inView: self)
        formTextField.anchor(left: imageView.rightAnchor, right: rightAnchor, paddingLeft: 5, height: 50)
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        addSubview(separatorView)
        separatorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.75)
        
        self.setHeight(height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
