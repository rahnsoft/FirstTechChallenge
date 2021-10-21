//
//  APIHelper.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import Foundation
import UIKit
let appDelegate = (UIApplication.shared.delegate) as? AppDelegate
func delay(_ delay: Double, closure: @escaping () -> ()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

final class APIHelper: NSObject {
    var isLoggedIn = false
    static let shared = APIHelper()
    
    static let appFontName = "Poppins-Regular"
    static let appBoldFontName = "Poppins-Bold"
    static let appMediumName = "Poppins-Medium"
    static let appTilteBoldFontName = "Poppins-ExtraBold"
    static let appSemiBoldFontName = "Poppins-SemiBold"
}

