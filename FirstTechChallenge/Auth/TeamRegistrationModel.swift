//
//  TeamModel.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 22/10/2021.
//

import Foundation
import UIKit

struct ViewActions {
    var placeHolderText: String?
    var tag: Int?
}

struct TeamRegistrationModel {
    var teamName: String
    var teamNumber: String
    var teamRobotName: String?
    var teamRegion: String?
    var teamPassword: String
    var isShareDetails: Bool = false
}
