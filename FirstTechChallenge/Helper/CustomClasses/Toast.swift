//
//  Toast.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 22/10/2021.
//

import Foundation
import SwiftMessages
import UIKit

class Toast: NSObject {
    static let shared = Toast()
    private var view: MessageView!
    private var config = SwiftMessages.Config()
    override init() {
        super.init()
        // setup view
        view = MessageView.viewFromNib(layout: .cardView)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        view.iconImageView?.isHidden = true
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView)?.cornerRadius = 10
        if let controller = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let current = controller.viewControllers.last?.presentedViewController {
                config.presentationContext = .view(current.view)
            } else {
                config.presentationContext = .automatic
            }
        } else {
            config.presentationContext = .automatic
        }
        // configure
        config.presentationStyle = .bottom
        config.duration = .automatic
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = false
        config.preferredStatusBarStyle = .lightContent
    }

    @discardableResult
    convenience init(_ message: String, type: Theme) {
        self.init()
        // set up message and type
        if UIApplication.shared.applicationState == .active {
            view.resignFirstResponder()
            view.endEditing(true)
            view.backgroundView.resignFirstResponder()
            view.backgroundView.endEditing(true)
            view.configureTheme(type)
            view.configureContent(body: message)
            SwiftMessages.show(config: config, view: view)
        }
    }
}

final class SuccessToast: Toast {
    @discardableResult
    convenience init(_ message: String) {
        self.init(message, type: .success)
    }
}

final class ErrorToast: Toast {
    @discardableResult
    convenience init(_ message: String) {
        self.init(message, type: .error)
    }
}

final class InfoToast: Toast {
    @discardableResult
    convenience init(_ message: String) {
        self.init(message, type: .info)
    }
}

final class WarningToast: Toast {
    @discardableResult
    convenience init(_ message: String) {
        self.init(message, type: .warning)
    }
}
