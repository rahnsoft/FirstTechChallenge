//
//  ProfileHeaderView.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 28/10/2021.
//

import Foundation
import UIKit

final class ProfileHeaderView: UIView {
    lazy var pencilButton: HavaRoundButton = {
        let iv = HavaRoundButton()
        iv.setImage(#imageLiteral(resourceName: "icon-edit-pencil").withRenderingMode(.alwaysTemplate), for: .normal)
        iv.tintColor = .textColor
        iv.clipsToBounds = true
        iv.isEnabled = false
        iv.imageView?.contentMode = .scaleAspectFit
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .paleGray
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.themeColor.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var profilePic: HavaRoundImageView = {
        let iv = HavaRoundImageView()
        iv.image = #imageLiteral(resourceName: "icon-placeholder-image")
        iv.tintColor = .textColor
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profilePic)
        addSubview(pencilButton)
        let angle: CGFloat = 45
        let heightConstant: CGFloat = 80
        let radius: CGFloat = heightConstant / 2
        let height_offset = sin(angle) * radius
        let base = ((radius * radius) - (height_offset * height_offset)).squareRoot()
        let constraints = [
            pencilButton.widthAnchor.constraint(equalToConstant: 30),
            pencilButton.heightAnchor.constraint(equalToConstant: 30),
            pencilButton.centerXAnchor.constraint(equalTo: profilePic.centerXAnchor, constant: base),
            pencilButton.centerYAnchor.constraint(equalTo: profilePic.centerYAnchor, constant: -height_offset),
            
            profilePic.topAnchor.constraint(equalTo: topAnchor, constant: HavaConstants.DOUBLE_PADDING),
            profilePic.centerXAnchor.constraint(equalTo: centerXAnchor),
            profilePic.heightAnchor.constraint(equalToConstant: heightConstant),
            profilePic.widthAnchor.constraint(equalToConstant: heightConstant),
            profilePic.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
