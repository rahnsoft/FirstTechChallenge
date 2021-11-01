//
//  File.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import Foundation
import UIKit
class HighScoreCell: UITableViewCell {
    var dataSourceItem: Any? {
        didSet {
            guard let source = dataSourceItem as? TeamScore else { return }
            teamId.text = source.teamid
            score.text = source.totalScore
            pointsLabel1.text = source.stage1
            pointsLabel2.text = source.stage2
            pointsLabel3.text = source.stage3
        }
    }

    lazy var scoreLabel: UILabel = {
        let l = UILabel()
        l.text = "Team score"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE + 1, titleColor: .textColor)
        l.backgroundColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var score: UILabel = {
        let l = UILabel()
        l.text = "30"
        l.styleForTitleView(appBoldFont: HavaConstants.LARGE_FONT_SIZE + 4, align: .center)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var teamIdLabel: UILabel = {
        let l = UILabel()
        l.text = "Team Id"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE, titleColor: .textColor)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var teamId: UILabel = {
        let l = UILabel()
        l.text = "103455"
        l.setupLabel(adjustsFontsizeToWidth: false, textAlign: .natural, _font: UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE))
        return l
    }()
    
    lazy var stage1Label: UILabel = {
        let l = UILabel()
        l.text = "Autonomous"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE, titleColor: .textColor)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var pointsLabel1: UILabel = {
        let l = UILabel()
        l.text = "10 points"
        l.setupLabel(adjustsFontsizeToWidth: false, textAlign: .natural, _font: UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE))
        return l
    }()
    
    lazy var stage2Label: UILabel = {
        let l = UILabel()
        l.text = "Driver-controlled period"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE, titleColor: .textColor)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var pointsLabel2: UILabel = {
        let l = UILabel()
        l.text = "10 points"
        l.setupLabel(adjustsFontsizeToWidth: false, textAlign: .natural, _font: UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE))
        return l
    }()
    
    lazy var stage3Label: UILabel = {
        let l = UILabel()
        l.text = "End Game"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE, titleColor: .textColor)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var pointsLabel3: UILabel = {
        let l = UILabel()
        l.text = "10 points"
        l.setupLabel(adjustsFontsizeToWidth: false, textAlign: .natural, _font: UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE))
        return l
    }()
    
    let rightChevron: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "icon-right-reveal").withRenderingMode(.alwaysTemplate), for: .normal)
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            b.imageEdgeInsets = UIEdgeInsets(top: 5, left: -5, bottom: 5, right: 5)
        } else {
            b.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        b.tintColor = .textColor
        return b
    }()
    
    var profileHeightAnchor: NSLayoutConstraint!
    var greetingsHeightAnchor: NSLayoutConstraint!
    var topAnchorConstant: NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        accessoryView = rightChevron
        rightChevron.frame.size.height = frame.height / 2
        rightChevron.frame.size.width = frame.height / 2
        rightChevron.sizeToFit()
        contentView.backgroundColor = .white
        backgroundColor = .white
        contentView.addSubview(scoreLabel)
        contentView.addSubview(score)
        contentView.addSubview(teamIdLabel)
        contentView.addSubview(teamId)
        contentView.addSubview(stage1Label)
        contentView.addSubview(pointsLabel1)
        contentView.addSubview(stage2Label)
        contentView.addSubview(pointsLabel2)
        contentView.addSubview(stage3Label)
        contentView.addSubview(pointsLabel3)
        
        scoreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: score.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        score.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        score.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        score.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        score.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        score.bottomAnchor.constraint(equalTo: teamIdLabel.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
            
        teamIdLabel.topAnchor.constraint(equalTo: score.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        teamIdLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width / 1.35).isActive = true
        teamIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
        teamIdLabel.bottomAnchor.constraint(equalTo: stage1Label.topAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        
        teamId.topAnchor.constraint(equalTo: teamIdLabel.topAnchor).isActive = true
        teamId.leadingAnchor.constraint(equalTo: teamIdLabel.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        teamId.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        teamId.bottomAnchor.constraint(equalTo: teamIdLabel.bottomAnchor).isActive = true
        
        stage1Label.topAnchor.constraint(equalTo: teamIdLabel.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        stage1Label.widthAnchor.constraint(equalToConstant: contentView.frame.width / 1.35).isActive = true
        stage1Label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
        stage1Label.bottomAnchor.constraint(equalTo: stage2Label.topAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
            
        pointsLabel1.topAnchor.constraint(equalTo: stage1Label.topAnchor).isActive = true
        pointsLabel1.leadingAnchor.constraint(equalTo: stage1Label.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        pointsLabel1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        pointsLabel1.bottomAnchor.constraint(equalTo: stage1Label.bottomAnchor).isActive = true
            
        stage2Label.topAnchor.constraint(equalTo: stage1Label.bottomAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        stage2Label.widthAnchor.constraint(equalTo: stage1Label.widthAnchor).isActive = true
        stage2Label.leadingAnchor.constraint(equalTo: stage1Label.leadingAnchor).isActive = true
        stage2Label.bottomAnchor.constraint(equalTo: stage3Label.topAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
            
        pointsLabel2.topAnchor.constraint(equalTo: stage2Label.topAnchor).isActive = true
        pointsLabel2.leadingAnchor.constraint(equalTo: stage2Label.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        pointsLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        pointsLabel2.bottomAnchor.constraint(equalTo: stage2Label.bottomAnchor).isActive = true
            
        stage3Label.topAnchor.constraint(equalTo: stage2Label.bottomAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        stage3Label.widthAnchor.constraint(equalTo: stage2Label.widthAnchor).isActive = true
        stage3Label.leadingAnchor.constraint(equalTo: stage2Label.leadingAnchor).isActive = true
        stage3Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
            
        pointsLabel3.topAnchor.constraint(equalTo: stage3Label.topAnchor).isActive = true
        pointsLabel3.leadingAnchor.constraint(equalTo: stage3Label.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        pointsLabel3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        pointsLabel3.bottomAnchor.constraint(equalTo: stage3Label.bottomAnchor).isActive = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
