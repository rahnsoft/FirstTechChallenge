//
//  ConfirmCancelView.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import UIKit
final class ConfirmCancelView: UIView {
    var completion: ((Bool) -> Void)?
    lazy var backgroundView: UIView = {
        let iv = UIView()
        iv.tag = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
        iv.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return iv
    }()

    let coverImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "image-logo").withRenderingMode(.alwaysOriginal)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let label: UILabel = {
        let l = UILabel()
        l.textColor = .textColor
        l.numberOfLines = .zero
        l.textAlignment = .center
        l.text = "This process is irreversible.\nAre you sure you want to continue? You can edit the scores by clicking on update."
        l.font = UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var confirmButton: UIButton = {
        let b = UIButton()
        b.tag = 0
        b.setCustomButtonStyle("Continue", background: .themeColor)
        b.titleEdgeInsets = .init(top: .zero, left: 8, bottom: .zero, right: 8)
        b.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return b
    }()

    lazy var cancelButton: UIButton = {
        let b = UIButton()
        b.tag = 1
        b.setCustomButtonStyle("Cancel", textColor: .themeColor, background: .lightGray)
        b.titleEdgeInsets = .init(top: .zero, left: 8, bottom: .zero, right: 8)
        b.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let containerView = UIView()
        containerView.layer.cornerRadius = 5
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.addSubview(label)
        containerView.addSubview(coverImage)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)

        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        let width = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: .zero, left: 32, bottom: .zero, right: 32)).width
        containerView.widthAnchor.constraint(equalToConstant: width).isActive = true

        let height = UIScreen.main.bounds.height / 10
        coverImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        coverImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        coverImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        coverImage.heightAnchor.constraint(equalToConstant: height * 1.6).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        label.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        label.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        cancelButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: min(height * 0.7, 50)).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true

        confirmButton.topAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        confirmButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: min(height * 0.7, 50)).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func cancel(_ sender: Any) {
        if let view = sender as? UIView {
            switch view.tag {
            case 0:
                completion?(true)
            default:
                completion?(false)
            }
        }
        removeFromSuperview()
        backgroundView.removeFromSuperview()
        if let window = UIApplication.shared.keyWindow {
            window.windowLevel = .normal
        }
    }

    func show() {
        if let window = UIApplication.shared.keyWindow {
            window.windowLevel = .alert
            window.addSubview(backgroundView)
            backgroundView.addSubview(self)
            backgroundView.frame = window.frame
            frame = CGRect(x: .zero, y: window.frame.height, width: window.frame.width, height: window.frame.height)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.frame = CGRect(x: .zero, y: .zero, width: window.frame.width, height: window.frame.height)
            }, completion: nil)
        }
    }
}
