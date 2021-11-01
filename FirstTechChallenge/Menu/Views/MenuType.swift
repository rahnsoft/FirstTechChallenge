//
//  MenuType.swift
//  MakeupApp
//
//  Created by IOS DEV PRO 1 on 05/10/2021.
//  Copyright © 2021 LTD. All rights reserved.
//

import Foundation
import UIKit

enum MenuType: Int {
    case teamScore
    case HighScore

    var title: String {
        switch self {
        case .teamScore:
            return "Team score"
        case .HighScore:
            return "High Score"
        }
    }

    var icon: UIImage? {
        switch self {
        case .teamScore:
            return #imageLiteral(resourceName: "image-reset")
        case .HighScore:
            return #imageLiteral(resourceName: "image-share-referral")
        }
    }
}
