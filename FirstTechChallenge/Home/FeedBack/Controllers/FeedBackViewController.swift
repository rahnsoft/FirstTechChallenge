//
//  FeedBackViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 31/10/2021.
//

import UIKit
import CoreLocation

class FeedBackViewController: UIViewController, ImageUploaded, UIGestureRecognizerDelegate {
    var teamScores: [TeamScores]?
    var filterScores: [TeamScores]?
    var isFromHome: Bool = false
    var scoreLocation: String?
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.separatorStyle = .singleLine
        tv.showsVerticalScrollIndicator = false
        tv.dataSource = self
        tv.tableHeaderView = UIView(frame: .zero)
        tv.tableFooterView = UIView(frame: .zero)
        tv.backgroundColor = .paleGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    lazy var submitView: ConfirmCancelView = {
        let v = ConfirmCancelView()
        return v
    }()

    lazy var searchController: UISearchController = {
        let v = UISearchController()
        v.setCustomSearchViewController(placeHolder: "Search items...")
        v.searchBar.delegate = self
        return v
    }()
    
    let locationManager = LocationManager.shared.locationManager
    
    convenience init(isFromHome: Bool = false) {
        self.init()
        self.isFromHome = isFromHome
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        APIHelper.shared.fetchScoreDetails((APIHelper.shared.getSavedTeam()?.loginTeamNumber)!) { _ in }
        teamScores = APIHelper.shared.getSavedTeamScores()?.sorted { Int($0.round ?? "0") ?? .zero > Int($1.round ?? "1") ?? 1 }
        filterScores =  APIHelper.shared.getSavedTeamScores()?.sorted { Int($0.round ?? "0") ?? .zero > Int($1.round ?? "1") ?? 1 }
        APIHelper.shared.delegate = self
        APIHelper.shared.fetchLoginDetails { _ in }
        view.backgroundColor = .paleGray
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.register(FeedBackCell.self, forCellReuseIdentifier: FeedBackCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationPermission()
        let textField = searchController.searchBar.value(forKey: "searchTextField") as? UITextField
        textField?.textColor = .lightGray
        textField?.tintColor = .lightGray
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        if !isFromHome {
            setupTitleAndRightButtonView(title: "Team score", isProfile: false)
            setupTitleAndBackButtonView(title: "Home", isBackAnimation: false)
            setupRightBarButton(isRight: false)
        } else {
            setupTitleAndRightButtonView(title: "Team score", isProfile: false)
            setupTitleAndBackButtonView(title: "Home", isBackAnimation: false)
            setupRightBarButton(isRight: true)
        }
    }

    func checkLocationPermission(){
        switch LocationManager.shared.locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            self.showAccessPhotos(title: "Allow Location", message: "Location access is denied. In order to get your region, please enable Location in the Settigs app under Privacy, Location Services.")
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {[self] in
                getUserLocation()
            }
        @unknown default:
            fatalError("Location misbehaved")
        }
    }
    
    func getUserLocation () {
        if let lat = locationManager.location?.coordinate.latitude , let long = locationManager.location?.coordinate.longitude {
        let location = CLLocation(latitude: lat, longitude: long)
        location.fetchCityAndCountry { city, country, error in
            if error == nil {
                guard let city = city, let country = country, error == nil else { return }
                self.scoreLocation = city + ", " + country
            } else {
                self.scoreLocation = "Not found"
                ErrorToast(error!.localizedDescription)
            }
        }
        }
    }
    
    func setupRightBarButton() {
        let attributedTitle = NSAttributedString(string: " Submit>".capitalized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                              NSAttributedString.Key.font: UIFont.appBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE),
                                                                                              NSAttributedString.Key.kern: 2])
        let b = UIButton()
        b.tintColor = .white
        b.sizeToFit()
        b.setAttributedTitle(attributedTitle, for: .normal)
        b.addTarget(self, action: #selector(submitViewShow), for: .touchUpInside)
        let back = UIBarButtonItem(customView: b)
        back.tintColor = .white
        navigationItem.backBtnString = ""
        navigationItem.rightBarButtonItem = back
    }

    func setupLeftBarButton() {
        let attributedTitle = NSAttributedString(string: " Restart".capitalized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                              NSAttributedString.Key.font: UIFont.appBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE),
                                                                                              NSAttributedString.Key.kern: 2])
        let b = UIButton()
        b.tintColor = .white
        b.sizeToFit()
        b.setImage(#imageLiteral(resourceName: "icon-left-chevron").withRenderingMode(.alwaysTemplate), for: .normal)
        b.setAttributedTitle(attributedTitle, for: .normal)
        b.addTarget(self, action: #selector(restartScoring), for: .touchUpInside)
        let back = UIBarButtonItem(customView: b)
        back.tintColor = .white
        navigationItem.backBtnString = ""
        navigationItem.leftBarButtonItem = back
    }

    func imageUploaded() {
        if !isFromHome {
            setupTitleAndRightButtonView(title: "Team score", isProfile: false)
            setupTitleAndBackButtonView(title: "Home", isBackAnimation: false)
            setupRightBarButton(isRight: false)
        } else {
            setupTitleAndRightButtonView(title: "Team score", isProfile: false)
            setupTitleAndBackButtonView(title: "Home", isBackAnimation: false)
            setupRightBarButton(isRight: true)
        }
        tableView.reloadData()
    }

    @objc func submitViewShow() {
        if APIHelper.shared.getSavedTeam()?.isShareDetails == true {
            submitView.coverImage.image = #imageLiteral(resourceName: "image-share-referral")
            submitView.label.text = "This process is irreversible.\nAre you sure you want to continue? You can cancel and edit the scores by clicking on update"
            submitView.confirmButton.removeTarget(self, action: #selector(goToProfile), for: .touchUpInside)
            submitView.confirmButton.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
        } else {
            submitView.coverImage.image = #imageLiteral(resourceName: "image-share")
            submitView.label.text = "Please allow share details first in the profile section to enable you submit the scores to the high score table and share your team details."
            submitView.confirmButton.removeTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
            submitView.confirmButton.addTarget(self, action: #selector(goToProfile), for: .touchUpInside)
        }
        submitView.show()
    }

    @objc func submitBtnAction() {
        UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
        if APIHelper.shared.getSavedTeam()?.isShareDetails == true {
            if let teamId = APIHelper.shared.getSavedTeam()?.loginTeamNumber {
                APIHelper.shared.submitScore(teamid: teamId.description, autonomous: HavaConstants.stage1Score.description, drivercontrolled: HavaConstants.stage2Score.description, endgame: HavaConstants.stage3Score.description, location: scoreLocation ?? APIHelper.shared.getSavedTeam()?.loginTeamRegion?.description ?? "") { data, _ in
                    if let responseData = data {
                        do {
                            let action = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject]
                            let result = action?["result"] as? String
                            let message = action?["message"] as? String
                            if result?.lowercased() == "success".lowercased() {
                                SuccessToast("Team score submitted")
                            } else {
                                if let msg = message?.lowercased().trimmingCharacters(in: .whitespaces), msg.contains("missing field".lowercased().trimmingCharacters(in: .whitespaces)) {
                                    ErrorToast("A team cannot score 0 in a stage")
                                }
                                ErrorToast(message ?? "")
                            }
                        } catch {}
                    }
                    UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
                }
            }
        }
    }

    @objc func restartScoring() {
        HavaConstants.hasRestarted = true
        HavaConstants.stage1Score = .zero
        HavaConstants.stage2Score = .zero
        HavaConstants.stage3Score = .zero
        let nav = UINavigationController(rootViewController: stage1ViewController())
        appDelegate?.makeRootViewController(nav, withAnimation: true)
    }
}

extension FeedBackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == .zero ? .zero : teamScores?.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedBackCell.identifier, for: indexPath) as? FeedBackCell ?? FeedBackCell()
        cell.profilePic.image = APIHelper.shared.getImage()
        cell.profilePic.isHidden = true
        cell.profileHeightAnchor.constant = .zero
        cell.topAnchorConstant.constant = .zero
        cell.selectionStyle = .none
        cell.dataSourceItem = teamScores?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == .zero ? UITableView.automaticDimension : .zero
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == numberOfSections(in: tableView) - 1 ? UITableView.automaticDimension : .zero
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == .zero {
            let headerView = FeedBackHeaderView()
            headerView.teamNameLabel.text = Date().timeLabel().capitalized + " " + ((APIHelper.shared.loginTeamDetails?.loginTeamName)?.capitalized ?? "")
            headerView.profilePic.image = APIHelper.shared.getImage()
            headerView.translatesAutoresizingMaskIntoConstraints = false

            let containerView = UIView()
            containerView.addSubview(headerView)
            containerView.backgroundColor = .clear
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToProfile))
            tapRecognizer.delegate = self
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.numberOfTouchesRequired = 1
            containerView.addGestureRecognizer(tapRecognizer)

            headerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
            headerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            headerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
            return containerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == numberOfSections(in: tableView) - 1 {
            let resetButton = UIButton()
            let attributedTitle = NSAttributedString(string: "Restart scoring".uppercased(), attributes: [.font: UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE + 1),
                                                                                                          .foregroundColor: UIColor.white])
            resetButton.setAttributedTitle(attributedTitle, for: .normal)
            resetButton.tintColor = .white
            resetButton.backgroundColor = .themeColor
            resetButton.layer.cornerRadius = 5
            resetButton.addTarget(self, action: #selector(restartScoring), for: .touchUpInside)
            resetButton.translatesAutoresizingMaskIntoConstraints = false

            let submitBtn = UIButton()
            let attributedTitleSubmit = NSAttributedString(string: "Submit scores".uppercased(), attributes: [.font: UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE + 1),
                                                                                                              .foregroundColor: UIColor.white])
            submitBtn.setAttributedTitle(attributedTitleSubmit, for: .normal)
            submitBtn.tintColor = .white
            submitBtn.backgroundColor = .themeColor
            submitBtn.layer.cornerRadius = 5
            submitBtn.addTarget(self, action: #selector(submitViewShow), for: .touchUpInside)
            submitBtn.translatesAutoresizingMaskIntoConstraints = false

            let containerView = UIView()
            containerView.addSubview(resetButton)
            containerView.addSubview(submitBtn)
            containerView.backgroundColor = .paleGray

            resetButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
            resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            resetButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
            resetButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2.8).isActive = true
            resetButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING * 3).isActive = true

            submitBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
            submitBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
            submitBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
            submitBtn.widthAnchor.constraint(equalToConstant: view.frame.width / 2.8).isActive = true
            submitBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING * 3).isActive = true
            return containerView
        }
        return nil
    }
}

extension FeedBackViewController: UISearchBarDelegate {
    // Filtering the array based on searchBar text
    func searchItems(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == false {
            teamScores = filterScores?.filter {
                ($0.totalScore?.lowercased().trimmingCharacters(in: .whitespaces).contains((searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces))!)) ?? false ||
                    ($0.createdAt?.lowercased().trimmingCharacters(in: .whitespaces).contains((searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces))!)) ?? false ||
                    ($0.round?.lowercased().trimmingCharacters(in: .whitespaces).contains((searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces))!)) ?? false
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
