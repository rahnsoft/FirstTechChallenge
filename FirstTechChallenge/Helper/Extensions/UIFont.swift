//
//  UIFont.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import Foundation
import UIKit
extension UIFont {
    static func appTitleFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: APIHelper.appFontName, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }

    static func appBoldTitleFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: APIHelper.appTilteBoldFontName, size: ofSize) ?? UIFont.boldSystemFont(ofSize: ofSize)
    }

    static func appFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: APIHelper.appFontName, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }

    static func appBoldFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: APIHelper.appBoldFontName, size: ofSize) ?? UIFont.boldSystemFont(ofSize: ofSize)
    }

    static func appSemiBoldFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: APIHelper.appBoldFontName, size: ofSize) ?? UIFont.boldSystemFont(ofSize: ofSize)
    }

    static func appMediumFont(ofSize: CGFloat) -> UIFont {
        return UIFont(name: APIHelper.appMediumName, size: ofSize) ?? UIFont.boldSystemFont(ofSize: ofSize)
    }
}
