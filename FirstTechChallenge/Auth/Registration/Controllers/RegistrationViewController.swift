//
//  RegistrationViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 20/10/2021.
//

import CoreLocation
import IQKeyboardManagerSwift
import UIKit

class RegistrationViewController: UIViewController {
    // Array of the textFields required
    let textFields: [ViewActions] = [ViewActions(placeHolderText: "Team Name *", tag: 0),
                                     ViewActions(placeHolderText: "Team Number *", tag: 1),
                                     ViewActions(placeHolderText: "Robot Name", tag: 2),
                                     ViewActions(placeHolderText: "Region", tag: 3),
                                     ViewActions(placeHolderText: "Password *", tag: 4),
                                     ViewActions(placeHolderText: "Confirm Password *", tag: 5)]

    var teamName: String = ""
    var teamNumber: String = ""
    var teamRobotName: String? = ""
    var teamRegion: String? = ""
    var teamPassword: String = ""
    var confirmPassword: String = ""
    let isShareToggle = UISwitch()

    // TableView Variable
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.tintColor = .black
        tv.rowHeight = UITableView.automaticDimension
        tv.delegate = self
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.dataSource = self
        tv.tableHeaderView = UIView(frame: .zero)
        tv.tableFooterView = UIView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .white
        return tv
    }()

    lazy var showShareModal: ConfirmCancelView = {
        let v = ConfirmCancelView()
        return v
    }()

    var hasShownModal: Bool = false
    let locationManager = LocationManager.shared.locationManager

    // MARK: - Setup tableview and register the tableviewCell

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        UserDefaults.standard.setValue(nil, forKey: "isRegistered")
        UserDefaults.standard.setValue(false, forKey: "isRegistered")
        setupTitleAndRightButtonView(title: "Registration", isProfile: false)
        setupTitleAndBackButtonView(title: "Login", isBackButton: true)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        tableView.register(RegistrationCell.self, forCellReuseIdentifier: RegistrationCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationPermission()
    }

    // MARK: - Check location permission

    func checkLocationPermission() {
        switch LocationManager.shared.locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            showAccessPhotos(title: "Allow Location", message: "Location access is denied. In order to get your region, please enable Location in the Settigs app under Privacy, Location Services.")
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async { [self] in
                getUserLocation()
            }
        @unknown default:
            fatalError("Location misbehaved")
        }
    }

    // MARK: - Get the location name from location coordinates

    func getUserLocation() {
        if let lat = locationManager.location?.coordinate.latitude, let long = locationManager.location?.coordinate.longitude {
            let location = CLLocation(latitude: lat, longitude: long)
            location.fetchCityAndCountry { city, country, error in
                if error == nil {
                    guard let city = city, let country = country, error == nil else { return }
                    self.teamRegion = city + ", " + country
                    self.tableView.reloadData()
                } else {
                    self.teamRegion = "Not found"
                    ErrorToast(error!.localizedDescription)
                }
            }
        }
    }

    // MARK: - Register a team

    @objc func registerTeam() {
        view.endEditing(true)
        if teamName.isEmpty {
            WarningToast("Team Name can not be empty")
        } else if teamNumber.isEmpty || teamNumber.count < 5 {
            WarningToast("Team number can nott be empty or less than 5 digits")

        } else if teamPassword.isEmpty || teamPassword.count < 6 {
            WarningToast("Password can not be empty or less than 6 characters")

        } else if confirmPassword.isEmpty || confirmPassword.count < 6 {
            WarningToast("Confirm password can not be empty or less than 6 characters")

        } else if confirmPassword != teamPassword {
            ErrorToast("Confirm password didn't match!")
        } else {
            UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
            let team = TeamRegistrationModel(teamName: teamName, teamNumber: teamNumber, teamRobotName: teamRobotName, teamRegion: teamRegion, teamPassword: confirmPassword, isShareDetails: isShareToggle.isOn)
            APIHelper.shared.createTeam(teamid: teamNumber, name: teamName, location: teamRegion ?? "") { data, _ in
                if let responseData = data {
                    do {
                        let action = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject]
                        let result = action?["result"] as? String
                        let message = action?["message"] as? String
                        if result?.lowercased() == "success".lowercased() {
                            APIHelper.shared.registerTeam(teamModel: team) { success, message in
                                if success {
                                    self.alreadyRegistered()
                                    SuccessToast("Team registered successfully")
                                } else {
                                    ErrorToast(message)
                                }
                            }
                        } else if result?.lowercased() == "error".lowercased() {
                            ErrorToast(message ?? "")
                        }
                    } catch {}
                }
                UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
            }
        }
    }

    @objc func alreadyRegistered() {
        UIView.transition(with: (appDelegate?.window)!, duration: 0.7, options: .transitionFlipFromRight) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Delgate methods for UiTableView

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFields.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationCell.identifier, for: indexPath) as? RegistrationCell ?? RegistrationCell()
        cell.dataSourceItem = textFields[indexPath.row]
        if textFields[indexPath.row].tag == 3 {
            cell.commonTextField.text = teamRegion
            cell.commonTextField.isUserInteractionEnabled = false
        }
        cell.commonTextField.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = "Welcome to the First Tech Challenge Score App. Please register to continue!"
        let linkTextWithColor = "First Tech Challange"
        let range = (headerText as NSString).range(of: linkTextWithColor)
        let attributedString = NSMutableAttributedString(string: headerText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: range)
        attributedString.addAttribute(.font, value: UIFont.appSemiBoldFont(ofSize: 16), range: range)

        let title = UILabel()
        title.textAlignment = .center
        title.numberOfLines = .zero
        title.textColor = .themeColor
        title.font = UIFont.appSemiBoldFont(ofSize: 14)
        title.attributedText = attributedString
        title.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(title)
        containerView.backgroundColor = .white

        title.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        return containerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func shareDetails() {
        isShareToggle.isOn = true
    }

    @objc func dontShareDetails() {
        isShareToggle.isOn = false
        hasShownModal = false
    }

    @objc func toggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            showShareModal.coverImage.image = #imageLiteral(resourceName: "image-share-referral")
            showShareModal.label.text = "By continuing, the team details and scores will be sent to our servers and made accessible to other teams.\n Do you wish to continue?"
            showShareModal.show()
            showShareModal.confirmButton.addTarget(self, action: #selector(shareDetails), for: .touchUpInside)
            showShareModal.cancelButton.addTarget(self, action: #selector(dontShareDetails), for: .touchUpInside)
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        isShareToggle.addTarget(self, action: #selector(toggleSwitch(_:)), for: .touchUpInside)
        isShareToggle.onTintColor = .themeColor
        isShareToggle.preferredStyle = .sliding
        isShareToggle.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.text = "Share team details".capitalized
        title.textColor = .themeColor
        title.font = UIFont.appSemiBoldFont(ofSize: 14)
        title.translatesAutoresizingMaskIntoConstraints = false

        let registerBtn = UIButton()
        registerBtn.setCustomButtonStyle("Register")
        registerBtn.contentEdgeInsets = UIEdgeInsets(top: .zero, left: HavaConstants.DEFAULT_PADDING * 3, bottom: .zero, right: HavaConstants.DEFAULT_PADDING * 3)
        registerBtn.addTarget(self, action: #selector(registerTeam), for: .touchUpInside)

        let headerText = "Already Registered? Login"
        let linkTextWithColor = "Login"
        let range = (headerText as NSString).range(of: linkTextWithColor)
        let attributedString = NSMutableAttributedString(string: headerText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: range)
        attributedString.addAttribute(.font, value: UIFont.appMediumFont(ofSize: 14), range: range)

        let alreadyRegisteredLabel = UILabel()
        alreadyRegisteredLabel.textAlignment = .center
        alreadyRegisteredLabel.numberOfLines = .zero
        alreadyRegisteredLabel.textColor = .themeColor
        alreadyRegisteredLabel.font = UIFont.appMediumFont(ofSize: 12)
        alreadyRegisteredLabel.attributedText = attributedString
        alreadyRegisteredLabel.isUserInteractionEnabled = true
        alreadyRegisteredLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(alreadyRegistered)))
        alreadyRegisteredLabel.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(isShareToggle)
        containerView.addSubview(title)
        containerView.addSubview(registerBtn)
        containerView.addSubview(alreadyRegisteredLabel)
        containerView.backgroundColor = .white

        isShareToggle.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        isShareToggle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        isShareToggle.trailingAnchor.constraint(equalTo: title.leadingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        isShareToggle.bottomAnchor.constraint(equalTo: registerBtn.topAnchor, constant: -HavaConstants.DEFAULT_PADDING * 3).isActive = true

        title.centerYAnchor.constraint(equalTo: isShareToggle.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: isShareToggle.trailingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true

        registerBtn.topAnchor.constraint(equalTo: isShareToggle.bottomAnchor, constant: HavaConstants.DEFAULT_PADDING * 3).isActive = true
        registerBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        registerBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING * 8).isActive = true
        registerBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DEFAULT_PADDING * 8).isActive = true
        registerBtn.bottomAnchor.constraint(equalTo: alreadyRegisteredLabel.topAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true

        alreadyRegisteredLabel.topAnchor.constraint(equalTo: registerBtn.bottomAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        alreadyRegisteredLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        alreadyRegisteredLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING * 3).isActive = true
        return containerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Delgate methods for UItextField

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == textFields.last?.tag {
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Register"
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(registerTeam))
        } else {
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Close"
        }
        if textField.tag == 1 || textField.tag == 4 || textField.tag == 5 {
            textField.keyboardType = .phonePad
        } else {
            textField.keyboardType = .default
        }
    }

    // MARK: - Set maximum character entry for Team Number

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            if !(updatedText.count <= 5) {
                ErrorToast("Team number can't exceed 5 digits")
                return updatedText.count <= 5
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            teamName = textField.text ?? ""
        case 1:
            teamNumber = textField.text ?? ""
        case 2:
            teamRobotName = textField.text ?? ""
        case 3:
            teamRegion = textField.text ?? ""
        case 4:
            teamPassword = textField.text ?? ""
        case 5:
            confirmPassword = textField.text ?? ""
        default:
            break
        }
    }
}
