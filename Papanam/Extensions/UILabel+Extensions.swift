//
//  UILabel+Extensions.swift
//  Papanam
//
//  Created by Jansen Ducusin on 5/1/21.
//

import UIKit

extension UILabel {
    static func createAppLabel() -> UILabel {
        let label = UILabel()
        label.text = "PAPANAM"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textAlignment = .center
        label.textColor = .themeWhiteText
        return label
    }
}
