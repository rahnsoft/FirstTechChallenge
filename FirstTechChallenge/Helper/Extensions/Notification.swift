//
//  Notification.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 22/10/2021.
//

import Foundation
import UIKit

extension Notification {
    var getKeyBoardHeight: CGFloat {
        let userInfo: NSDictionary = self.userInfo! as NSDictionary
        let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        let keyboardRectangle = keyboardFrame?.cgRectValue
        return keyboardRectangle?.height ?? .zero
    }
}
