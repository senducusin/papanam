//
//  UIImage+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

extension UIImage {
    static let email = UIImage(systemName: "envelope")
    static let password = UIImage(systemName: "lock")
    static let fullname = UIImage(systemName: "person")
    static let userType = UIImage(systemName: "person.circle")
    
    static let backImage = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysOriginal)
    
    static let menuImage = UIImage(systemName: "line.horizontal.3")?.withRenderingMode(.alwaysOriginal)
    
    static let driverAnnotation = UIImage(systemName: "chevron.right.circle.fill")?.withRenderingMode(.alwaysOriginal)
}
