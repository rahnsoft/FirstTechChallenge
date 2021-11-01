//
//  Stage1Model.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 30/10/2021.
//

import Foundation
import UIKit

// Model for the different score types
struct StageModel {
    var headerLabel: String?
    var pointsValue: [String: Any]?
    init(key: String?, values: [String: Any]) {
        self.headerLabel = key
        self.pointsValue = values
    }

    static var stage1: [StageModel] {
        let stageOne = [StageModel(key: "", values: ["Delivered Duck via Carousel": 10]),
                        StageModel(key: "Navigating", values: ["Parked In Alliance Storage Unit": 3,
                                                               "Parked Completely In Alliance Storage Unit": 6,
                                                               "Parked In Warehouse": 5,
                                                               "Parked Completely In Warehouse": 10]),
                        StageModel(key: "", values: ["Freight Completely In Alliance Storage Unit": 2,
                                                     "Freight Completely On Alliance Shipping Hub": 6]),
                        StageModel(key: "Autonomous Bonus", values: ["Duck used to detect Shipping Hub Level": 10,
                                                                     "Team Scoring Element used to detect Shipping Hub Level": 20])]
        return stageOne
    }

    static var stage2: [StageModel] {
        let stageTwo = [StageModel(key: "", values: ["Freight Completely In Alliance Storage Unit": 1]),
                        StageModel(key: "Freight in Alliance Shipping Hub", values: ["Level 1": 2,
                                                                                     "Level 2": 4,
                                                                                     "Level 3": 6]),
                        StageModel(key: "", values: ["Freight Completely On Shared Shipping Hub": 4]),
                        StageModel(key: "Autonomous Bonus", values: ["Duck used to detect Shipping Hub Level": 10,
                                                                     "Team Scoring Element used to detect Shipping Hub Level": 20])]
        return stageTwo
    }

    static var stage3: [StageModel] {
        let endGame = [StageModel(key: "", values: ["Delivered Duck or Team Shipping Element via Carousel": 6,
                                                    "Alliance Shipping Hub Balanced": 10,
                                                    "Shared Shipping Hub tipped toward Alliance": 20,
                                                    "Parked partially in a Warehouse": 3,
                                                    "Parked Completely in a Warehouse": 6,
                                                    "Alliance Shipping Hub Capped": 15])]
        return endGame
    }
}
