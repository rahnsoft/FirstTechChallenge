//
//  File.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 21/10/2021.
//

import JVFloatLabeledTextField
import UIKit

final class LeftPaddedTexfField: JVFloatLabeledTextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    override var textColor: UIColor? {
        didSet {
            floatingLabelTextColor = textColor
            floatingLabelActiveTextColor = textColor
        }
    }

    override var font: UIFont? {
        didSet {
            floatingLabelFont = font
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        floatingLabelTextColor = .black
        floatingLabelActiveTextColor = .black
        alwaysShowFloatingLabel = true
        floatingLabelYPadding = -20
        floatingLabelXPadding = -4
        floatingLabelFont = UIFont.appSemiBoldFont(ofSize: 14)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        font = .appFont(ofSize: 16)
        textColor = .black
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
