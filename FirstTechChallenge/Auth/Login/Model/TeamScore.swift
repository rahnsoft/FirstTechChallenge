//
//  TeamModel.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import Foundation
import UIKit

struct TeamScore: Codable {
    var teamid: String?
    var stage1: String?
    var stage2: String?
    var stage3: String?
    var totalScore: String?
    var location: String?

    private enum CodingKeys: String, CodingKey {
        case teamid = "teamid"
        case stage1 = "autonomous"
        case stage2 = "drivercontrolled"
        case stage3 = "endgame"
        case totalScore = "score"
    }
}

struct Team: Codable {
    var id: String?
    var name: String?
    var location: String?
    var image: String?
    var created: String?
}
