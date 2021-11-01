//
//  ProfileEditCell.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 28/10/2021.
//

import UIKit

final class ProfileEditCell: UITableViewCell {
    let header: UILabel = {
        let l = UILabel()
        l.font = UIFont.appMediumFont(ofSize: 14)
        l.textColor = .lightGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let field: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.appFont(ofSize: 14)
        tf.textColor = .textColor
        tf.rightViewMode = .always
        tf.isUserInteractionEnabled = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    lazy var chevronImage: UIButton = {
        let b = UIButton()
        b.isEnabled = false
        b.setImage(#imageLiteral(resourceName: "icon-right-reveal").withRenderingMode(.alwaysTemplate), for: .normal)
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            b.imageEdgeInsets = .init(top: 5, left: -5, bottom: 5, right: 5)
        } else {
            b.imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        }
        b.isHidden = true
        b.adjustsImageWhenDisabled = false
        b.tintColor = .textColor
        b.contentMode = .scaleAspectFit
        return b
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        backgroundColor = .white
        contentView.addSubview(header)
        contentView.addSubview(field)
        accessoryView = chevronImage
        accessoryView?.tintColor = .textColor
        let constraints = [header.topAnchor.constraint(equalTo: contentView.topAnchor, constant: HavaConstants.DEFAULT_PADDING),
                           header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING),
                           header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING),
                           header.bottomAnchor.constraint(equalTo: field.topAnchor, constant: -HavaConstants.DEFAULT_PADDING),

                           field.topAnchor.constraint(equalTo: header.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING),
                           field.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING),
                           field.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING),
                           field.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING)]
        NSLayoutConstraint.activate(constraints)
        chevronImage.frame.size.height = frame.height / 2
        chevronImage.frame.size.width = frame.height / 2
        chevronImage.sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
