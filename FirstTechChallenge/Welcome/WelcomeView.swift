//
//  View.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 19/10/2021.
//

import Foundation
import UIKit
class WelcomeView: UIView {
    // ftcLogo ImageView
    lazy var ftcLogo: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "image-logo")
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // fflogo imageview
    lazy var ffLogo: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "image-frenzy")
        v.isHidden = true
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    // MARK: - Setup the views using auto layouts

    func setupViews() {
        addSubview(ftcLogo)
        addSubview(ffLogo)
        
        ftcLogo.topAnchor.constraint(equalTo: topAnchor, constant: HavaConstants.DOUBLE_PADDING * 5).isActive = true
        ftcLogo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ftcLogo.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3.5).isActive = true
        ftcLogo.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - HavaConstants.DEFAULT_PADDING * 8).isActive = true
        
        ffLogo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING * 2).isActive = true
        ffLogo.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4).isActive = true
        ffLogo.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5).isActive = true
        ffLogo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
