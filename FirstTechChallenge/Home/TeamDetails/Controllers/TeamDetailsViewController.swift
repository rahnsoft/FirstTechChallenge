//
//  TeamDetailsViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import UIKit
import Kingfisher

class TeamDetailsViewController: UIViewController {
    var team: Team?
    var teamScore: TeamScore?
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.separatorStyle = .singleLine
        tv.showsVerticalScrollIndicator = false
        tv.dataSource = self
        tv.tableHeaderView = UIView(frame: .zero)
        tv.tableFooterView = UIView(frame: .zero)
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleAndRightButtonView(title: "Team Details", isProfile: false)
        setupTitleAndBackButtonView(title: "Scores", isBackAnimation: false)
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.register(HighScoreCell.self, forCellReuseIdentifier: HighScoreCell.identifier)
    }

    convenience init(teamId: String, teamScore: TeamScore) {
        self.init()
        self.teamScore = teamScore
        UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
        APIHelper.shared.getSingleTeam(teamid: teamId) { team, _ in
            self.team = team
            self.tableView.reloadData()
        }
    }
}

extension TeamDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == .zero ? .zero : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HighScoreCell.identifier, for: indexPath) as? HighScoreCell ?? HighScoreCell()
        cell.dataSourceItem = teamScore
        cell.scoreLabel.text = ("Location:" + " " + (team?.location?.capitalized ?? ""))
        cell.accessoryView = nil
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == numberOfSections(in: tableView) - 1 ? UITableView.automaticDimension : .zero
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == .zero {
            let headerView = FeedBackHeaderView()
            headerView.teamNameLabel.text = team?.name?.capitalized
            if let profilePicUrl = team?.image, let url = URL(string: profilePicUrl) {
                headerView.profilePic.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                headerView.profilePic.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "icon-placeholder-image").withRenderingMode(.alwaysTemplate))
            }
            headerView.translatesAutoresizingMaskIntoConstraints = false
            let containerView = UIView()
            containerView.addSubview(headerView)
            containerView.backgroundColor = .clear

            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
            headerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            headerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
            return containerView
        }
        return nil
    }
}
