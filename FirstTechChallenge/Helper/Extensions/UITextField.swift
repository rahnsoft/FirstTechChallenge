//
//  UITextField.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 21/10/2021.
//

import Foundation
import UIKit

extension UITextField {
    func customizeForRegistrationView(_ name: String) {
        layer.cornerRadius = 2
        placeholder = name
        font = .appFont(ofSize: font!.pointSize)
        returnKeyType = .next
//        addBorder(edges: [.top,.bottom], colour:  UIColor.lightGray.withAlphaComponent(0.4), thickness: 2, leftPadding: .zero, rightPadding: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .natural
        autocorrectionType = .no
        autocapitalizationType = .none
    }

    func customizeForSearchView() {
        layer.cornerRadius = 2
        font = UIFont.appFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE)
        returnKeyType = .next
        addBorder(edges: .bottom, colour: UIColor.lightGray.withAlphaComponent(0.2), thickness: 2, leftPadding: .zero, rightPadding: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .natural
        autocorrectionType = .no
        autocapitalizationType = .none
        textColor = .lightGray
        placeholder = nil
    }

    func addIcon(_ image: UIImage?, color: UIColor = .white) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let button = HavaRoundButton()
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = color
        button.backgroundColor = UIColor.systemRed.withAlphaComponent(0.7)
        view.addSubview(button)

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(4)-[button(20)]-(4)-|", options: [], metrics: nil, views: ["button": button]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[button(width)]-(8)-|", options: [], metrics: ["width": image == nil ? .zero : 20], views: ["button": button]))
        rightViewMode = .always
        rightView = view
    }
}

public class HavaRoundButton: UIButton {
    override public func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    }
}
