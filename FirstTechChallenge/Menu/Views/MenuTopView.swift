//
//  MenuTopView.swift
//  MakeupApp
//
//  Created by IOS DEV PRO 1 on 05/10/2021.
//  Copyright © 2021 LTD. All rights reserved.
//

import Foundation
import UIKit

final class MenuTopView: UIView {
    lazy var profilePicture: HavaRoundImageView = {
        let iv = HavaRoundImageView()
        iv.tintColor = .paleGray
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "icon-placeholder-image").withRenderingMode(.alwaysTemplate)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let userNameLabel: UILabel = {
        let l = UILabel()
        l.text = APIHelper.shared.getSavedTeam()?.loginTeamName?.uppercased()
        l.font = UIFont.boldSystemFont(ofSize: HavaConstants.LARGE_FONT_SIZE)
        l.textAlignment = .natural
        l.textColor = .black
        l.isUserInteractionEnabled = true
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var profileBtn: UIButton = {
        let l = UIButton()
        l.tag = 3
        let attributedTitle = NSAttributedString(string: "View Profile", attributes: [.foregroundColor: UIColor(hexString: "#00824F"),
                                                                                      .font: UIFont.boldSystemFont(ofSize: HavaConstants.LARGE_FONT_SIZE - 2),
                                                                                      .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                                                      .underlineColor: UIColor(hexString: "#00824F")])
        l.setAttributedTitle(attributedTitle, for: .normal)
        l.contentHorizontalAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var containerView: UIView = {
        let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        let leftView = UIView()
        leftView.contentMode = .scaleAspectFit
        leftView.layer.masksToBounds = true
        leftView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(leftView)
        leftView.addSubview(profilePicture)
        let rightView = UIView()
        rightView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(rightView)
        rightView.addSubview(userNameLabel)
        rightView.addSubview(profileBtn)

        let height = max(min(UIScreen.main.bounds.height / 5, 80), 80)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        leftView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        leftView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        leftView.trailingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        leftView.widthAnchor.constraint(equalTo: leftView.heightAnchor).isActive = true
        leftView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        profilePicture.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: height).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: height).isActive = true

        rightView.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING * 2).isActive = true
        rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        rightView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        rightView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING * 2).isActive = true

        userNameLabel.topAnchor.constraint(equalTo: rightView.topAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: profileBtn.heightAnchor).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: profileBtn.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        profileBtn.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        profileBtn.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        profileBtn.heightAnchor.constraint(equalTo: userNameLabel.heightAnchor).isActive = true
        profileBtn.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        profileBtn.bottomAnchor.constraint(equalTo: rightView.bottomAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class AppRoundImageView: UIImageView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
    }
}
