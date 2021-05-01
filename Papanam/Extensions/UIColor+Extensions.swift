//
//  UIColor+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//
import UIKit

extension UIColor {
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

// MARK: - Theme
extension UIColor {
    static let themeBlack = UIColor.rgba(red: 25, green: 25, blue: 25, alpha: 1)
    static let themeBlue = UIColor.rgba(red: 17, green: 154, blue: 237, alpha: 1)
    
    static let themeWhiteText = UIColor(white: 1, alpha: 0.8)
}
