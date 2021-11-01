//
//  PointsCell.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 30/10/2021.
//

import Foundation
import UIKit

class PointsCell: UITableViewCell {
    // Set the check mark on selected rows
    var checked: Bool! {
        didSet {
            self.accessoryType = checked ? .checkmark : .none
        }
    }

    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.setupLabel(adjustsFontsizeToWidth: false, textAlign: .natural, _font: UIFont.appMediumFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE))
        return l
    }()

    lazy var pointsLabel: UILabel = {
        let l = UILabel()
        l.text = "10 points"
        l.setupLabel(adjustsFontsizeToWidth: false, textAlign: .natural, _font: UIFont.appMediumFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE))
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        checked = false
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(pointsLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width / 1.32).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true

        pointsLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        pointsLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
