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

extension Date {
    func timeLabel() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 : return "Good morning"
        case 12 ..< 17:  return "Good afternoon"
        case 17..<22 : return "Good evening"
        default: return "Good night"
    }
    }

}
