//
//  UIString.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import Foundation
import UIKit
extension String {
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
}
