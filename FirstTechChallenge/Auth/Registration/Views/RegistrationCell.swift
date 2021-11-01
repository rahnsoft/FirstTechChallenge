//
//  RegistrationCell.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 21/10/2021.
//

import Foundation
import JVFloatLabeledTextField
import UIKit

class RegistrationCell: UITableViewCell {
    // Setup the placeholder for the placeHolderText
    var dataSourceItem: Any? {
        didSet {
            guard let source = dataSourceItem as? ViewActions else { return }
            let attributedPlaceHolder = NSAttributedString(string: "Enter" + " " + source.placeHolderText!.replacingOccurrences(of: "*", with: "").lowercased(), attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                                                                                                                                              .foregroundColor: UIColor.lightGray])
            commonTextField.setAttributedPlaceholder(attributedPlaceHolder, floatingTitle: source.placeHolderText!)
            commonTextField.tag = source.tag!
        }
    }

    lazy var commonTextField: LeftPaddedTexfField = {
        let f = LeftPaddedTexfField()
        f.customizeForRegistrationView("text_firstname")
        f.floatingLabelFont = UIFont.appSemiBoldFont(ofSize: 14)
        f.textColor = .textColor
        f.tintColor = .textColor
        f.floatingLabelTextColor = .textColor
        f.floatingLabelActiveTextColor = .textColor
        f.autocapitalizationType = .words
        f.isUserInteractionEnabled = true
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    // MARK: - Setup the views

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.backgroundColor = .white
        selectionStyle = .none
        contentView.addSubview(commonTextField)
        commonTextField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        commonTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        commonTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        commonTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        commonTextField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
