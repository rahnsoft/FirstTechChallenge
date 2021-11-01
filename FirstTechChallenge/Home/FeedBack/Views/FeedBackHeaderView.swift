//
//  HomeView.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import Foundation
import UIKit

class FeedBackHeaderView: UIView {
    lazy var teamNameLabel: UILabel = {
        let l = UILabel()
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE + 1, titleColor: .textColor)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var profilePic: HavaRoundImageView = {
        let iv = HavaRoundImageView()
        iv.image = #imageLiteral(resourceName: "image-logo")
        iv.tintColor = .textColor
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(teamNameLabel)
        addSubview(profilePic)
        let heightConstant: CGFloat = 80
        let constraints: [NSLayoutConstraint] = [
        teamNameLabel.topAnchor.constraint(equalTo: topAnchor),
        teamNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        teamNameLabel.bottomAnchor.constraint(equalTo: profilePic.topAnchor, constant: -HavaConstants.DEFAULT_PADDING),
        
        profilePic.topAnchor.constraint(equalTo: teamNameLabel.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING),
        profilePic.centerXAnchor.constraint(equalTo: centerXAnchor),
        profilePic.heightAnchor.constraint(equalToConstant: heightConstant),
        profilePic.widthAnchor.constraint(equalToConstant: heightConstant),
        profilePic.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
