//
//  Stage2ViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 30/10/2021.
//

import UIKit
import  CoreLocation

class EndGameViewController: UIViewController {
    var model: [StageModel]?
    var stageModel: [StageModel]? {
        get {
            return model ?? StageModel.stage1
        } set {
            model = newValue
        }
    }

    var scoreLocation: String?
    let locationManager = LocationManager.shared.locationManager
    var isSelectedCell = false
    var stage3Score = 0
    let score = UILabel()
    var stage: Int = .zero
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
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

    convenience init(stageModel: [StageModel], stage: Int) {
        self.init()
        self.stage = stage
        self.stageModel = stageModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleAndRightButtonView(title: "End Game", isProfile: false)
        setupTitleAndBackButtonView(title: "Back", isBackAnimation: false)
        setupRightBarButton(isRight: true)
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        tableView.register(PointsCell.self, forCellReuseIdentifier: PointsCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationPermission()
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
    
    @objc func finish() {
        HavaConstants.hasRestarted = false
        HavaConstants.stage3Score = stage3Score
        HavaConstants.scoreRound += 1
        if stage3Score == .zero {
            ErrorToast("Score cannot be zero!")
        } else {
            UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
            APIHelper.shared.saveScoreDetails(teamNumber: (APIHelper.shared.getSavedTeam()?.loginTeamNumber)!, location: scoreLocation ?? "") { success, message in
                if success {
                    SuccessToast("Score saved")
                    let nav = UINavigationController(rootViewController: FeedBackViewController())
                    appDelegate?.makeRootViewController(nav)
                } else {
                    ErrorToast(message)
                }
                UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
            }
        }
    }
}

// MARK: - Delegate methods for the tableView

extension EndGameViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return stageModel!.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stageModel![section].pointsValue?.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PointsCell.identifier, for: indexPath) as? PointsCell ?? PointsCell()
        cell.titleLabel.text = stageModel![indexPath.section].pointsValue?.sorted { $0.key > $1.key }[indexPath.row].key
        cell.pointsLabel.text = "\((stageModel![indexPath.section].pointsValue?.sorted { $0.key > $1.key }[indexPath.row].value)!)" + " " + "Points"
        cell.selectedBackgroundView?.backgroundColor = .white
        cell.selectionStyle = .none
        cell.tintColor = .greenPrimaryColor
        return cell
    }

    // Header for the tableview
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == .zero {
            let headerText = UILabel()
            headerText.text = "Score"
            headerText.textAlignment = .center
            headerText.numberOfLines = .zero
            headerText.textColor = .themeColor
            headerText.font = UIFont.appSemiBoldFont(ofSize: 18)
            headerText.translatesAutoresizingMaskIntoConstraints = false

            score.text = stage3Score.description
            score.textAlignment = .center
            score.numberOfLines = .zero
            score.textColor = .greenPrimaryColor
            score.font = UIFont.appSemiBoldFont(ofSize: 60)
            score.translatesAutoresizingMaskIntoConstraints = false
            score.layoutIfNeeded()

            let greetingsText = UILabel()
            greetingsText.text = "Please click on a row to award points."
            greetingsText.textAlignment = .center
            greetingsText.numberOfLines = .zero
            greetingsText.textColor = .themeColor
            greetingsText.font = UIFont.appSemiBoldFont(ofSize: HavaConstants.DEFAULT_FONT_SIZE)
            greetingsText.translatesAutoresizingMaskIntoConstraints = false

            let containerView = UIView()
            containerView.addSubview(headerText)
            containerView.addSubview(score)
            containerView.addSubview(greetingsText)
            containerView.backgroundColor = .paleGray

            headerText.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING / 2).isActive = true
            headerText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            headerText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            headerText.bottomAnchor.constraint(equalTo: score.topAnchor).isActive = true

            score.topAnchor.constraint(equalTo: headerText.bottomAnchor).isActive = true
            score.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            score.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            score.bottomAnchor.constraint(equalTo: greetingsText.topAnchor).isActive = true

            greetingsText.topAnchor.constraint(equalTo: score.bottomAnchor).isActive = true
            greetingsText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            greetingsText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            greetingsText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING / 2).isActive = true
            return containerView
        } else {
            let headerText = UILabel()
            headerText.text = stageModel![section].headerLabel?.uppercased()
            headerText.textAlignment = .natural
            headerText.numberOfLines = .zero
            headerText.textColor = .lightGray
            headerText.font = UIFont.appSemiBoldFont(ofSize: HavaConstants.LARGE_FONT_SIZE - 2)
            headerText.translatesAutoresizingMaskIntoConstraints = false

            let containerView = UIView()
            containerView.addSubview(headerText)
            containerView.backgroundColor = .paleGray

            headerText.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            headerText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
            headerText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            headerText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
            return containerView
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 {
            let nextStage = UIButton()
            nextStage.setCustomButtonStyle("Finish")
            nextStage.addTarget(self, action: #selector(finish), for: .touchUpInside)
            nextStage.translatesAutoresizingMaskIntoConstraints = false

            let containerView = UIView()
            containerView.addSubview(nextStage)
            containerView.backgroundColor = .clear

            nextStage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
            nextStage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            nextStage.heightAnchor.constraint(equalToConstant: 50).isActive = true
            nextStage.widthAnchor.constraint(equalToConstant: view.frame.width / 2.8).isActive = true
            nextStage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true

            return containerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return stageModel![section].headerLabel?.count == .zero && section != .zero ? .zero : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    // Show the checkmark and change the score
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [self] in
            let cell = tableView.cellForRow(at: indexPath) as? PointsCell
            cell?.checked = !(cell?.checked)!
            isSelectedCell = (cell?.checked)!
            if cell?.checked == true {
                stage3Score += Int("\((stageModel![indexPath.section].pointsValue?.sorted { $0.key > $1.key }[indexPath.row].value)!)")!
            } else {
                stage3Score -= Int("\((stageModel![indexPath.section].pointsValue?.sorted { $0.key > $1.key }[indexPath.row].value)!)")!
            }
            score.text = stage3Score.description
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
