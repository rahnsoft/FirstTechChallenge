//
//  UIButton.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 22/10/2021.
//

import Foundation
import UIKit
extension UIButton {
    func setCustomButtonStyle(titleUpperCased: Bool = true,
                              _ title: String,
                              textColor: UIColor = .white,
                              background: UIColor = .themeColor,
                              font: UIFont = UIFont.appSemiBoldFont(ofSize: HavaConstants.LARGE_FONT_SIZE - 2))
    {
        layer.cornerRadius = 5
        backgroundColor = background
        let localizedTile = titleUpperCased ? title.uppercased() : title
        let attributedTitle = NSAttributedString(string: localizedTile,
                                                 attributes: [NSAttributedString.Key.kern: 2.0,
                                                              NSAttributedString.Key.foregroundColor: textColor,
                                                              NSAttributedString.Key.font: font])
        setAttributedTitle(attributedTitle, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
