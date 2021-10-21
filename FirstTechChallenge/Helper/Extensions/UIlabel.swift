//
//  UIlabel.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import Foundation
import UIKit
extension UILabel {
    func styleForTitleView(titleUpperCased: Bool = true,
                           _ title: String,
                           appBoldFont: CGFloat = 20,
                           titleColor: UIColor = .textColor)
    {
        textAlignment = .left
        let localised = title.localize.isEmpty ? title : titleUpperCased ? title.localize.uppercased() : title.localize
        let att = NSAttributedString(string: localised,
                                     attributes: [NSAttributedString.Key.foregroundColor: titleColor,
                                                  NSAttributedString.Key.font: UIFont.appBoldFont(ofSize: appBoldFont),
                                                  NSAttributedString.Key.kern: 2])
        attributedText = att
        sizeToFit()
        adjustsFontSizeToFitWidth = true
    }

    func setCustomUILabelStyle(_textColor: UIColor = .textColor,
                               havaConstantsFont: CGFloat = HavaConstants.DEFAULT_FONT_SIZE,
                               adjustsFontsizeToWidth: Bool = false,
                               textAlign: NSTextAlignment = .natural,
                               _text: String? = nil)
    {
        text = _text
        textAlignment = textAlign
        textColor = _textColor
        font = UIFont.appFont(ofSize: havaConstantsFont)
        adjustsFontSizeToFitWidth = adjustsFontsizeToWidth
        contentMode = .scaleAspectFit
        sizeToFit()
        translatesAutoresizingMaskIntoConstraints = false
    }
}
