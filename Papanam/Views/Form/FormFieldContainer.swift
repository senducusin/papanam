//
//  FormFieldContainer.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

class FormFieldContainer: UIView {
    init(formTextField: FormTextField? = nil, segmentedControl: UISegmentedControl? = nil, icon: UIImage?){
        super.init(frame: .zero)
        
        let imageView = UIImageView()
        imageView.image = icon
        imageView.alpha = 0.87
        imageView.tintColor = .white
        
        addSubview(imageView)
        
        
        if let formTextField = formTextField {
            imageView.setDimensions(height: 20, width: 23)
            imageView.centerY(inView: self)
            imageView.anchor(left: leftAnchor)
            
            addSubview(formTextField)
            formTextField.centerY(inView: self)
            formTextField.anchor(left: imageView.rightAnchor, right: rightAnchor, paddingLeft: 5, height: 50)
            
            setHeight(height: 50)
        }else if let segmentedControl = segmentedControl {
            imageView.setDimensions(height: 23, width: 23)
            imageView.anchor(top: topAnchor, left: leftAnchor)
            
            addSubview(segmentedControl)
            segmentedControl.anchor(left:leftAnchor, bottom: bottomAnchor, right:rightAnchor, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
            
            setHeight(height: 70)
        }
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        addSubview(separatorView)
        separatorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.75)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
