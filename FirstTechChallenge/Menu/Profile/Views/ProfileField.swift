
//
//  ProfileField.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 28/10/2021.
//

import Foundation

enum ProfileField: String {
    case teamName
    case teamNumber
    case robotName
    case region
    case password
    case shareDetails
    case signout

    var value: String {
        return self.rawValue
    }
}
