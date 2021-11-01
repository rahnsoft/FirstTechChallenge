//
//  UIViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import EzPopup
import Foundation
import SideMenu
import UIKit

extension UIViewController {
    func setupTitleAndBackButtonView(title: String, back image: UIImage = #imageLiteral(resourceName: "icon-left-chevron"), isTintColor: Bool = true, isBackButton: Bool = true, isBackAnimation: Bool = true) {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.tintColor = .white

        let attributedTitle = NSAttributedString(string: title.capitalized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                         NSAttributedString.Key.font: UIFont.appBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE),
                                                                                         NSAttributedString.Key.kern: 2])
        let b = UIButton()
        if isBackButton {
            b.setImage(image.imageFlippedForRightToLeftLayoutDirection().withRenderingMode(isTintColor ? .alwaysTemplate : .alwaysOriginal), for: .normal)
        }
        b.tintColor = .white
        b.sizeToFit()
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            b.contentEdgeInsets = UIEdgeInsets(top: HavaConstants.DEFAULT_PADDING,
                                               left: .zero,
                                               bottom: HavaConstants.DEFAULT_PADDING,
                                               right: HavaConstants.DEFAULT_PADDING)
            b.titleEdgeInsets = .init(top: .zero, left: -HavaConstants.DEFAULT_PADDING, bottom: .zero, right: HavaConstants.DEFAULT_PADDING)
        } else {
            b.contentEdgeInsets = UIEdgeInsets(top: HavaConstants.DEFAULT_PADDING,
                                               left: .zero,
                                               bottom: HavaConstants.DEFAULT_PADDING,
                                               right: HavaConstants.DOUBLE_PADDING)
            b.titleEdgeInsets = .init(top: .zero, left: HavaConstants.DEFAULT_PADDING, bottom: .zero, right: -HavaConstants.DEFAULT_PADDING)
        }
        b.setAttributedTitle(attributedTitle, for: .normal)
        if isBackAnimation {
            b.addTarget(self, action: #selector(popBackWithAnimation), for: .touchUpInside)
        } else {
            b.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        }
        let back = UIBarButtonItem(customView: b)
        back.tintColor = .white
        navigationItem.backBtnString = ""

        navigationItem.leftBarButtonItem = back
    }

    func setupTitleAndRightButtonView(title: String, image: UIImage = APIHelper.shared.getImage(), isTintColor: Bool = true, isProfile: Bool = true, isProfileRight: Bool = true) {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = .themeColor
        navigationController?.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .themeColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance

        let profilePic = HavaRoundImageView()
        profilePic.image = image
        profilePic.tintColor = .white
        profilePic.clipsToBounds = true
        profilePic.contentMode = .scaleAspectFill
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfile)))
        profilePic.isHidden = !isProfile
        profilePic.translatesAutoresizingMaskIntoConstraints = false

        let profileLabel = UILabel()
        profileLabel.styleForAttributedTitleView(titleUpperCased: false, "", appBoldFont: HavaConstants.DEFAULT_FONT_SIZE, titleColor: .white)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(profilePic)
        containerView.addSubview(profileLabel)
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToProfile)))
        profilePic.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        profilePic.trailingAnchor.constraint(equalTo: profileLabel.leadingAnchor, constant: -8).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profilePic.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        profileLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileLabel.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8).isActive = true
        profileLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 14).isActive = true
        let back = UIBarButtonItem(customView: containerView)
        back.tintColor = .white
        navigationItem.backBtnString = ""
        if isProfileRight {
            navigationItem.rightBarButtonItem = isProfile ? back : nil
        } else {
            navigationItem.leftBarButtonItem = isProfile ? back : nil
        }
        let titleView = UILabel()
        titleView.styleForAttributedTitleView(titleUpperCased: true, title, appBoldFont: HavaConstants.LARGE_FONT_SIZE - 2, titleColor: .white)
        navigationItem.titleView = titleView
    }

    func setupRightBarButton(isRight: Bool = true, title: String = "All Scores >") {
        let b = UIButton()
        b.tintColor = .white
        b.sizeToFit()
        b.setImage(#imageLiteral(resourceName: "icon-menu").withRenderingMode(.alwaysTemplate), for: .normal)
        b.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        let back = UIBarButtonItem(customView: b)
        back.tintColor = .white
        navigationItem.backBtnString = ""
        if !isRight {
            navigationItem.leftBarButtonItem = back
        } else {
            navigationItem.rightBarButtonItem = back
        }
    }

    // MARK: - An alert for when the user has denied photos permission

    func showAccessPhotos(title: String?, message: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let notNowAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        alert.addAction(notNowAction)

        let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
            // Open app privacy settings
            self.openAppSettings()
        }

        alert.addAction(openSettingsAction)
        present(alert, animated: true, completion: nil)
    }

    @objc func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url)
        else {
            assertionFailure("Not able to open App privacy settings")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc func showMenu() {
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = .white
        presentationStyle.menuStartAlpha = 0.8
        presentationStyle.onTopShadowOpacity = 0.4
        presentationStyle.presentingEndAlpha = 0.8
        presentationStyle.menuOnTop = true

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.statusBarEndAlpha = 0
        let menu = SideMenuNavigationController(rootViewController: MenuController())
        menu.presentationStyle = .menuSlideIn
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            menu.leftSide = false
        } else {
            menu.leftSide = true
        }
        menu.settings = settings
        if UIDevice.current.userInterfaceIdiom == .phone {
            menu.menuWidth = view.frame.width - 120
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            menu.menuWidth = view.frame.width / 2
        }
        menu.navigationBar.isHidden = true
        present(menu, animated: true, completion: nil)
    }

    @objc func goToProfile() {
        let popupVC = PopupViewController(contentController: ProfileViewController(), popupWidth: view.frame.width - 32, popupHeight: view.frame.height / 1.5)
        popupVC.backgroundAlpha = 0.3
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = true
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = true
        present(popupVC, animated: true)
    }

    @objc func goToProfileWithAnimation() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }

    @objc func popBack(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

    @objc func popBackWithAnimation(_ sender: UITapGestureRecognizer) {
        UIView.transition(with: (appDelegate?.window)!, duration: 0.7, options: .transitionFlipFromRight) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    var topBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0) + view.layoutMargins.top
    }
}

extension UINavigationItem {
    var backBtnString: String {
        get { return "" }
        set { backBarButtonItem = UIBarButtonItem(title: newValue, style: .plain, target: nil, action: nil) }
    }
}

extension UISearchController {
    func setCustomSearchViewController(placeHolder: String? = "Search") {
        hidesNavigationBarDuringPresentation = true
        obscuresBackgroundDuringPresentation = false
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = placeHolder
        searchBar.showsCancelButton = true
        searchBar.searchTextField.backgroundColor = .lightGray
        searchBar.searchTextField.leftView?.tintColor = .paleGray
        searchBar.searchTextField.rightView?.tintColor = .paleGray
        searchBar.sizeToFit()
    }
}
