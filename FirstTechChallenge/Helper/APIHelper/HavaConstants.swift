//
//  HavaConstants.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import Foundation
import UIKit

final class HavaConstants: NSObject {
    static let shared = HavaConstants()
    static let DEFAULT_PADDING: CGFloat = 8
    static let DOUBLE_PADDING: CGFloat = 16
    static let DEFAULT_LANGUAGE_CODE = "en"
    static let MAX_FILE_SIZE: Int = 2000000
    static var LARGE_FONT_SIZE: CGFloat = 16
    static let EXTRA_LARGE_FONT: CGFloat = 20
    static let MAP_TIMER_ESTIMATE: Double = 30
    static var DEFAULT_FONT_SIZE: CGFloat = 12
    static let allTeamUrl = "http://www.partiklezoo.com/freightfrenzy/?action=teams"
    static let allScoresUrl = "https://www.partiklezoo.com/freightfrenzy/?"
    static let createTeam = "https://www.partiklezoo.com/freightfrenzy/?action=addteam&id=%@&name=%@&location=%@"
    static let singleTeam = "http://www.partiklezoo.com/freightfrenzy/?action=team&id=%@"
    static let submitScore = "https://www.partiklezoo.com/freightfrenzy/?action=addscore&teamid=%@&autonomous=%@&drivercontrolled=%@&endgame=%@&location=%@"
    static let aboutUrl = "https://firstinspiresst01.blob.core.windows.net/first-forward-ftc/game-one-page.pdf"
    static let moreInfoUrl = "https://www.firstinspires.org/resource-library/ftc/game-and-season-info"
    static var stage1Score: Int {
        get {
            return UserDefaults.standard.integer(forKey: "stage1")
        } set {
            UserDefaults.standard.set(newValue, forKey: "stage1")
        }
    }

    static var stage2Score: Int {
        get {
            return UserDefaults.standard.integer(forKey: "stage2")
        } set {
            UserDefaults.standard.set(newValue, forKey: "stage2")
        }
    }

    static var stage3Score: Int {
        get {
            return UserDefaults.standard.integer(forKey: "stage3")
        } set {
            UserDefaults.standard.set(newValue, forKey: "stage3")
        }
    }

    static var hasRestarted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasRestarted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "hasRestarted")
        }
    }
    
    static var scoreRound: Int {
        get {
            return UserDefaults.standard.integer(forKey: "scoreRound")
        } set {
            UserDefaults.standard.set(newValue, forKey: "scoreRound")
        }
    }
    
    override init() {
        super.init()
    }

    var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }
}
