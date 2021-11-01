//
//  FeedBackswift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import Foundation
import UIKit
class FeedBackCell: UITableViewCell {
    var dataSourceItem: Any? {
        didSet {
            guard let source = dataSourceItem as? TeamScores else { return }
            roundLabel.text =  "Round" + " " + (source.round ?? "")
            score.text = source.createdAt ?? ""
            scoreLabel.text = source.totalScore?.description ?? "No score"
            pointsLabel1.text = source.stage1Score ?? "No score"
            pointsLabel2.text = source.stage2Score ?? "No score"
            pointsLabel3.text = source.stage3Score ?? "No score"
        }
    }

    lazy var roundLabel: UILabel = {
        let l = UILabel()
        l.text = "Round 1"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE + 1, align: .center)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var teamNameLabel: UILabel = {
        let l = UILabel()
        l.text = "Team score"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE + 1, titleColor: .textColor)
        l.backgroundColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
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

    lazy var scoreLabel: UILabel = {
        let l = UILabel()
        l.text = "Score"
        l.styleForTitleView(appBoldFont: HavaConstants.LARGE_FONT_SIZE + 4, align: .center)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var score: UILabel = {
        let l = UILabel()
        l.text = "30"
        l.styleForTitleView(appBoldFont: HavaConstants.DEFAULT_FONT_SIZE + 1, align: .center)
        l.translatesAutoresizingMaskIntoConstraints = false
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
    
    var profileHeightAnchor: NSLayoutConstraint!
    var greetingsHeightAnchor: NSLayoutConstraint!
    var topAnchorConstant: NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        backgroundColor = .white
        contentView.addSubview(roundLabel)
        contentView.addSubview(teamNameLabel)
        contentView.addSubview(profilePic)
        contentView.addSubview(scoreLabel)
        contentView.addSubview(score)
        contentView.addSubview(stage1Label)
        contentView.addSubview(pointsLabel1)
        contentView.addSubview(stage2Label)
        contentView.addSubview(pointsLabel2)
        contentView.addSubview(stage3Label)
        contentView.addSubview(pointsLabel3)
        
        roundLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        roundLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
        
        topAnchorConstant = teamNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: HavaConstants.DEFAULT_PADDING)
        topAnchorConstant.isActive = true
        greetingsHeightAnchor = teamNameLabel.heightAnchor.constraint(equalToConstant: 20)
        greetingsHeightAnchor.isActive = true
        teamNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        topAnchorConstant = teamNameLabel.bottomAnchor.constraint(equalTo: profilePic.topAnchor, constant: -HavaConstants.DEFAULT_PADDING)
        topAnchorConstant.isActive = true
            
        topAnchorConstant = profilePic.topAnchor.constraint(equalTo: teamNameLabel.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING)
        topAnchorConstant.isActive = true
        profilePic.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileHeightAnchor = profilePic.heightAnchor.constraint(equalToConstant: 80)
        profileHeightAnchor.isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 80).isActive = true
        topAnchorConstant = profilePic.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: -HavaConstants.DEFAULT_PADDING)
        topAnchorConstant.isActive = true
            
        topAnchorConstant = scoreLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING)
        topAnchorConstant.isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: score.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
            
        score.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        score.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        score.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        score.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        score.bottomAnchor.constraint(equalTo: stage1Label.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
            
        stage1Label.topAnchor.constraint(equalTo: score.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        stage1Label.widthAnchor.constraint(equalToConstant: contentView.frame.width / 1.2).isActive = true
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
