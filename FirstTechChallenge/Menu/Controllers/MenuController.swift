//
//  MenuController.swift
//  MakeupApp
//
//  Created by IOS DEV PRO 1 on 05/10/2021.
//  Copyright © 2021 LTD. All rights reserved.
//

import UIKit

protocol DisplayContentControllerDelegate {
    func tabDidSelectAction(_ sender: UIView)
}

final class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImageUploaded {
    private var menuList: [MenuType] = [.teamScore, .HighScore]
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.estimatedRowHeight = 50
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: .zero)
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    lazy var bottomContainerView: UIView = {
        let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var finalBottomContainerView: UIView = {
        let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var seperatorView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var bottomSeperatorView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var profileView: MenuTopView = {
        let iv = MenuTopView()
        iv.profileBtn.addTarget(self, action: #selector(goToProfileWithAnimation), for: .touchUpInside)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    lazy var privacyLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE)
        l.textAlignment = .natural
        l.textColor = UIColor(hexString: "#00824F")
        l.adjustsFontSizeToFitWidth = true
        l.isUserInteractionEnabled = true
        l.minimumScaleFactor = 0.1
        l.text = "Privacy policy" + " •"
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCopyRight)))
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var termsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE)
        l.textAlignment = .natural
        l.textColor = UIColor(hexString: "#00824F")
        l.adjustsFontSizeToFitWidth = true
        l.isUserInteractionEnabled = true
        l.minimumScaleFactor = 0.1
        l.text = "Terms of Service"
        l.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCopyRight)))
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    lazy var ftcBtn: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "image-logo-1"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.isUserInteractionEnabled = true
        b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSite)))
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    fileprivate func setupViews() {
        imageUploaded()
        view.addSubview(tableView)
        view.addSubview(profileView)
        view.addSubview(seperatorView)
        view.addSubview(bottomContainerView)
        view.addSubview(bottomSeperatorView)
        view.backgroundColor = .white
        bottomContainerView.backgroundColor = .white
        tableView.contentInset.top = (CGFloat(50 * 3) - tableView.contentSize.height) / 2
        tableView.contentInset.bottom = (CGFloat(50 * 3) - tableView.contentSize.height) / 2
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        bottomContainerView.addSubview(termsLabel)
        bottomContainerView.addSubview(privacyLabel)
        bottomContainerView.addSubview(ftcBtn)
        profileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: view.frame.height / 5).isActive = true
        profileView.bottomAnchor.constraint(equalTo: seperatorView.topAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        seperatorView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        seperatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperatorView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -HavaConstants.DEFAULT_PADDING * 3).isActive = true

        let tableHeight = CGFloat(50 * 3)
        tableView.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomSeperatorView.topAnchor, constant: -HavaConstants.DEFAULT_PADDING * 3).isActive = true

        bottomSeperatorView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
        bottomSeperatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        bottomSeperatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        bottomSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomSeperatorView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: -16).isActive = true

        bottomContainerView.topAnchor.constraint(equalTo: bottomSeperatorView.bottomAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16).isActive = true

        privacyLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        privacyLabel.trailingAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        privacyLabel.bottomAnchor.constraint(equalTo: privacyLabel.bottomAnchor).isActive = true

        termsLabel.topAnchor.constraint(equalTo: privacyLabel.topAnchor).isActive = true
        termsLabel.leadingAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        termsLabel.bottomAnchor.constraint(equalTo: termsLabel.bottomAnchor).isActive = true

        ftcBtn.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        ftcBtn.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor).isActive = true
        ftcBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        ftcBtn.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, multiplier: 0.6).isActive = true
    }

    func imageUploaded() {
        profileView.profilePicture.image = APIHelper.shared.getImage()
    }

    // MARK: - Tableview delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as? MenuCell ?? MenuCell()
        cell.selectionStyle = .none
        cell.dataSourceItem = menuList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menuList[indexPath.row]
        switch item {
        case .teamScore:
            navigationController?.pushViewController(FeedBackViewController(isFromHome: true), animated: true)
        case .HighScore:
            navigationController?.pushViewController(HighScoresViewController(), animated: true)
        }
    }

    // Open copyright
    @objc fileprivate func openCopyRight() {
        navigationController?.pushViewController(WebViewController(), animated: true)
    }

    // Open more info website
    @objc fileprivate func openSite() {
        if let url = URL(string: HavaConstants.moreInfoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
