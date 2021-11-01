//
//  AllScoresViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import UIKit

class HighScoresViewController: UIViewController {
    var teamScores: [TeamScore]?
    var filterScores: [TeamScore]?
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

    lazy var searchController: UISearchController = {
        let v = UISearchController()
        v.setCustomSearchViewController(placeHolder: "Search items...")
        v.searchBar.delegate = self
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllScores()
        setupTitleAndRightButtonView(title: "High Scores", isProfile: false)
        setupTitleAndBackButtonView(title: "Back", isBackAnimation: false)
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.register(HighScoreCell.self, forCellReuseIdentifier: HighScoreCell.identifier)
    }

    // MARK: - setup the search Controller

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textField = searchController.searchBar.value(forKey: "searchTextField") as? UITextField
        textField?.textColor = .lightGray
        textField?.tintColor = .lightGray
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    func getAllScores() {
        UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
        APIHelper.shared.getAllScores { teamScores, _ in
            self.teamScores = teamScores
            self.filterScores = teamScores
            self.tableView.reloadData()
            UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
        }
    }
}

extension HighScoresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamScores?.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HighScoreCell.identifier, for: indexPath) as? HighScoreCell ?? HighScoreCell()
        cell.dataSourceItem = teamScores?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let teamScore = teamScores?[indexPath.row], let teamId = teamScore.teamid {
            let nav = TeamDetailsViewController(teamId: teamId, teamScore: teamScore)
            navigationController?.pushViewController(nav, animated: true)
        }
    }
}

// MARK: - Searching the High scores based on location, teamid, or totalscore

extension HighScoresViewController: UISearchBarDelegate {
    // Filtering the array based on searchBar text
    func searchItems(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == false {
            teamScores = filterScores?.filter {
                ($0.location?.lowercased().trimmingCharacters(in: .whitespaces).contains((searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces))!)) ?? false ||
                    ($0.teamid?.lowercased().trimmingCharacters(in: .whitespaces).contains((searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces))!)) ?? false ||
                    ($0.totalScore?.lowercased().trimmingCharacters(in: .whitespaces).contains((searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces))!)) ?? false
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            self.searchItems(searchBar)
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.teamScores = self.filterScores
            self.tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            self.searchItems(searchBar)
            self.tableView.reloadData()
        }
    }
}
