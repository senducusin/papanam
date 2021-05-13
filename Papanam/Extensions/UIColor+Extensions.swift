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
    static let themeDarkGray = UIColor.rgba(red: 216, green: 215, blue: 217, alpha: 1)
    static let themeLightGray = UIColor.rgba(red: 240, green: 238, blue: 242, alpha: 1)
    
    static let themeWhiteText = UIColor(white: 1, alpha: 0.87)
    static let themeDarkRed = UIColor(red: 0.40, green: 0.00, blue: 0.00, alpha: 1.00)
    static let themeRed = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
}
