//
//  MenuCell.swift
//  MakeupApp
//
//  Created by IOS DEV PRO 1 on 05/10/2021.
//  Copyright © 2021 LTD. All rights reserved.
//

import UIKit

final class MenuCell: UITableViewCell {
    var dataSourceItem: Any? {
        didSet {
            guard let menu = dataSourceItem as? MenuType else { return }
            menuLabel.text = menu.title
            menuImage.image = menu.icon?.withRenderingMode(.alwaysOriginal)
        }
    }

    var menuLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = UIFont.appMediumFont(ofSize: HavaConstants.LARGE_FONT_SIZE - 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .natural
        return l
    }()

    var menuImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(menuLabel)
        contentView.addSubview(menuImage)
        menuImage.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        menuImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        menuImage.trailingAnchor.constraint(equalTo: menuLabel.leadingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        menuImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        menuImage.heightAnchor.constraint(equalTo: menuImage.widthAnchor).isActive = true
        menuImage.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true

        menuLabel.leadingAnchor.constraint(equalTo: menuImage.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        menuLabel.centerYAnchor.constraint(equalTo: menuImage.centerYAnchor).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
