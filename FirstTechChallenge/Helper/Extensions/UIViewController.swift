//
//  UIViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import Foundation
import UIKit

extension UIViewController {
    func setupTitleAndBackButtonView(title: String, back image: UIImage = #imageLiteral(resourceName: "icon-back-button"), isTintColor: Bool = true, isBackButton: Bool = true) {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.tintColor = .white

        let attributedTitle = NSAttributedString(string: title.uppercased(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                          NSAttributedString.Key.font: UIFont.appBoldFont(ofSize: HavaConstants.EXTRA_LARGE_FONT),
                                                                                          NSAttributedString.Key.kern: 2])
        let b = UIButton()
        if isBackButton {
        b.setImage(image.withRenderingMode(isTintColor ? .alwaysTemplate : .alwaysOriginal), for: .normal)
        }
        b.tintColor = .white
        b.sizeToFit()
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            b.contentEdgeInsets = UIEdgeInsets(top: HavaConstants.DEFAULT_PADDING,
                                               left: -HavaConstants.DEFAULT_PADDING,
                                               bottom: HavaConstants.DEFAULT_PADDING,
                                               right: HavaConstants.DEFAULT_PADDING)
            b.titleEdgeInsets = .init(top: .zero, left: -HavaConstants.DEFAULT_PADDING, bottom: .zero, right: HavaConstants.DEFAULT_PADDING)
        } else {
            b.contentEdgeInsets = UIEdgeInsets(top: HavaConstants.DEFAULT_PADDING,
                                               left: HavaConstants.DEFAULT_PADDING,
                                               bottom: HavaConstants.DEFAULT_PADDING,
                                               right: HavaConstants.DOUBLE_PADDING)
            b.titleEdgeInsets = .init(top: .zero, left: HavaConstants.DEFAULT_PADDING, bottom: .zero, right: -HavaConstants.DEFAULT_PADDING)
        }
        b.setAttributedTitle(attributedTitle, for: .normal)
        b.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        let back = UIBarButtonItem(customView: b)
        back.tintColor = .white
        navigationItem.backBtnString = ""

        navigationItem.leftBarButtonItem = back
        self.title = nil
    }

    @objc func popBack(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

    var topBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0) + view.layoutMargins.top
    }
}

extension UINavigationItem {
    var backBtnString: String {
        get { return "" }
        set { self.backBarButtonItem = UIBarButtonItem(title: newValue, style: .plain, target: nil, action: nil) }
    }
}
