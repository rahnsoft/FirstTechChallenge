//
//  LoginViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 20/10/2021.
//

import IQKeyboardManagerSwift
import UIKit

class LoginViewController: UIViewController {
    // Array of the textFields required
    let textFields: [ViewActions] = [ViewActions(placeHolderText: "Team Number", tag: 0),
                                     ViewActions(placeHolderText: "Password", tag: 1)]

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
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    var teamNumberTextField = UITextField()
    var passTextfield = UITextField()
    var confirmPassTextfield = UITextField()
    var loginTeamNumber = ""
    var loginPassword = ""
    var forgotTeamNumber = ""
    var forgotPassword = ""
    var confirmPassword = ""

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.locationManager.requestAlwaysAuthorization()
        view.backgroundColor = .themeColor
        teamNumberTextField.delegate = self
        passTextfield.delegate = self
        setupTitleAndBackButtonView(title: "", isBackButton: false)
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: HavaConstants.DEFAULT_PADDING * 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING * 5).isActive = true
        tableView.register(RegistrationCell.self, forCellReuseIdentifier: RegistrationCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Take the user to registration if not registered

    @objc func notRegistered() {
        let controller = RegistrationViewController()
        UIView.transition(with: (appDelegate?.window)!, duration: 0.7, options: .transitionFlipFromLeft) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    // MARK: - Show an alert to change the password

    @objc func changePassword() {
        let forgotPasswordAlert = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
        forgotPasswordAlert.addTextField { [self] numberTextField in
            numberTextField.placeholder = "Enter team Number"
            teamNumberTextField = numberTextField
            teamNumberTextField.delegate = self
            teamNumberTextField.tag = 2
        }

        forgotPasswordAlert.addTextField { [self] passwordTextField in
            passwordTextField.placeholder = "Enter password"
            passTextfield = passwordTextField
            passTextfield.delegate = self
            passTextfield.tag = 3
        }

        forgotPasswordAlert.addTextField { [self] confirmTextField in
            confirmTextField.placeholder = "Confirm password"
            confirmPassTextfield = confirmTextField
            confirmPassTextfield.delegate = self
            confirmPassTextfield.tag = 4
        }

        // Action to change the password after validation
        let updateAction = UIAlertAction(title: "Submit", style: .default) { [self] _ in
            if forgotTeamNumber.isEmpty || forgotTeamNumber.count < 5 {
                WarningToast("Team number can not be empty or less than 5 digits")

            } else if forgotPassword.isEmpty || forgotPassword.count < 6 {
                WarningToast("Password can not be empty or less than 6 characters")

            } else if confirmPassword.isEmpty || confirmPassword.count < 6 {
                WarningToast("Confirm password can not be empty or less than 6 characters")

            } else if confirmPassword != forgotPassword {
                ErrorToast("Confirm password didn't match!")
            } else {
                APIHelper.shared.fetchRegistrationDetails(teamNumber: forgotTeamNumber) { success in
                    if success {
                        if APIHelper.shared.registrationTeamDetails?.teamNumber == nil {
                            ErrorToast("Team does not exist")
                        } else if APIHelper.shared.registrationTeamDetails?.teamNumber == self.forgotTeamNumber {
                            APIHelper.shared.changePassword(teamNumber: forgotTeamNumber, newPassword: confirmPassword) { success in
                                if success {
                                    SuccessToast("Success.Please login with the new password!")
                                } else {
                                    ErrorToast("Please try again and check your details!")
                                }
                            }
                        }
                    } else {
                        ErrorToast("Team does not exist")
                    }
                }
            }
        }
        forgotPasswordAlert.addAction(updateAction)
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        present(forgotPasswordAlert, animated: true) {
            forgotPasswordAlert.view.isUserInteractionEnabled = true
            forgotPasswordAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissForgotPasswordAlert)))
        }
    }

    // Dismiss the alertView on tapping the superview
    @objc func dismissForgotPasswordAlert() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Fetch to confirm team exists and save the details and login the team

    func newlogiLogic() {
        UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
        APIHelper.shared.getSingleTeam(teamid: loginTeamNumber) { team, error in
            if error == nil {
                APIHelper.shared.saveLoginDetailsApi(loginTeamName: (team?.name)!, loginTeamNumber: (team?.id)!, loginTeamRegion: (team?.location)!) { success, message in
                    if success {
                        SuccessToast(message)
                        let nav = UINavigationController(rootViewController: stage1ViewController())
                        appDelegate?.makeRootViewController(nav, withAnimation: true)
                    } else {
                        ErrorToast(message)
                    }
                }
            } else {
                ErrorToast(error!.localizedDescription)
            }
            UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
        }
    }

    @objc func loginTeam(completion: @escaping (Bool) -> ()) {
        APIHelper.shared.fetchRegistrationDetails(teamNumber: loginTeamNumber) { success in
            if success {
                if APIHelper.shared.registrationTeamDetails?.teamNumber == nil {
                    self.newlogiLogic()
                } else if APIHelper.shared.registrationTeamDetails?.teamNumber == self.loginTeamNumber {
                    if APIHelper.shared.registrationTeamDetails?.teamPassword == self.loginPassword {
                        APIHelper.shared.saveLoginDetails { success, message in
                            if success {
                                SuccessToast(message)
                                let nav = UINavigationController(rootViewController: stage1ViewController())
                                appDelegate?.makeRootViewController(nav, withAnimation: true)
                            } else {
                                ErrorToast(message)
                            }
                            completion(success)
                        }
                    } else {
                        ErrorToast("Incorrect Password!")
                    }

                } else {
                    self.newlogiLogic()
                }
            } else {
                self.newlogiLogic()
            }
        }
    }

    // MARK: - Perform validation and login

    @objc func validateAndLogin() {
        view.endEditing(true)
        if loginTeamNumber.isEmpty || loginTeamNumber.count < 5 {
            WarningToast("Team number can not be empty or less than 5 digits")
        } else if loginPassword.isEmpty || loginPassword.count < 6 {
            WarningToast("Password can not be empty or less than 6 characters")
        } else {
            loginTeam { complete in
                if complete {
                    let nav = UINavigationController(rootViewController: stage1ViewController())
                    appDelegate?.makeRootViewController(nav)
                }
            }
        }
    }

    // MARK: - ShowCopyRight view with the rules pdf

    @objc func openCopyRight() {
        navigationController?.pushViewController(WebViewController(), animated: true)
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFields.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationCell.identifier, for: indexPath) as? RegistrationCell ?? RegistrationCell()
        cell.dataSourceItem = textFields[indexPath.row]
        cell.commonTextField.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let logoImgView = UIImageView()
        logoImgView.image = #imageLiteral(resourceName: "image-logo").withRenderingMode(.alwaysOriginal)
        logoImgView.contentMode = .scaleAspectFit
        logoImgView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(logoImgView)
        containerView.backgroundColor = .white

        logoImgView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        logoImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        logoImgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        logoImgView.heightAnchor.constraint(equalToConstant: view.frame.height / 6).isActive = true
        logoImgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING * 5).isActive = true
        return containerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerText = "Not Registered? Sign up"
        let linkTextWithColor = "Sign up"
        let range = (headerText as NSString).range(of: linkTextWithColor)
        let attributedString = NSMutableAttributedString(string: headerText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: range)
        attributedString.addAttribute(.font, value: UIFont.appMediumFont(ofSize: 15), range: range)

        let copyRightText = "@ Copyright 2021. About"
        let copyLinkTextWithColor = "About"
        let copyRange = (copyRightText as NSString).range(of: copyLinkTextWithColor)
        let attributedStringCopy = NSMutableAttributedString(string: copyRightText)
        attributedStringCopy.addAttribute(.foregroundColor, value: UIColor.greenPrimaryColor, range: copyRange)
        attributedStringCopy.addAttribute(.font, value: UIFont.appMediumFont(ofSize: 15), range: copyRange)

        let loginButton = UIButton()
        loginButton.setCustomButtonStyle("Login")
        loginButton.addTarget(self, action: #selector(validateAndLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        let noRegisteredLabel = UILabel()
        noRegisteredLabel.textAlignment = .center
        noRegisteredLabel.numberOfLines = .zero
        noRegisteredLabel.textColor = .themeColor
        noRegisteredLabel.font = UIFont.appMediumFont(ofSize: 12)
        noRegisteredLabel.attributedText = attributedString
        noRegisteredLabel.isUserInteractionEnabled = true
        noRegisteredLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notRegistered)))
        noRegisteredLabel.translatesAutoresizingMaskIntoConstraints = false

        let forgrotPasswordLabel = UILabel()
        forgrotPasswordLabel.text = "Forgot Password?"
        forgrotPasswordLabel.textAlignment = .center
        forgrotPasswordLabel.numberOfLines = .zero
        forgrotPasswordLabel.textColor = .greenPrimaryColor.withAlphaComponent(0.8)
        forgrotPasswordLabel.font = UIFont.appMediumFont(ofSize: 12)
        forgrotPasswordLabel.isUserInteractionEnabled = true
        forgrotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePassword)))
        forgrotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false

        let copyright = UILabel()
        copyright.textColor = .themeColor
        copyright.attributedText = attributedStringCopy
        copyright.textAlignment = .center
        copyright.numberOfLines = .zero
        copyright.font = UIFont.appMediumFont(ofSize: 12)
        copyright.isUserInteractionEnabled = true
        copyright.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCopyRight)))
        copyright.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(loginButton)
        containerView.addSubview(noRegisteredLabel)
        containerView.addSubview(forgrotPasswordLabel)
        containerView.addSubview(copyright)
        containerView.backgroundColor = .white

        loginButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: noRegisteredLabel.topAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true

        noRegisteredLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        noRegisteredLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        noRegisteredLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        noRegisteredLabel.bottomAnchor.constraint(equalTo: forgrotPasswordLabel.topAnchor, constant: -HavaConstants.DOUBLE_PADDING).isActive = true

        forgrotPasswordLabel.topAnchor.constraint(equalTo: noRegisteredLabel.bottomAnchor, constant: HavaConstants.DOUBLE_PADDING).isActive = true
        forgrotPasswordLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        forgrotPasswordLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        forgrotPasswordLabel.bottomAnchor.constraint(equalTo: copyright.topAnchor, constant: -HavaConstants.DOUBLE_PADDING * 4).isActive = true

        copyright.topAnchor.constraint(equalTo: forgrotPasswordLabel.bottomAnchor, constant: HavaConstants.DOUBLE_PADDING * 4).isActive = true
        copyright.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        copyright.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        copyright.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        return containerView
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            loginTeamNumber = textField.text ?? ""
        case 1:
            loginPassword = textField.text ?? ""
        case 2:
            forgotTeamNumber = textField.text ?? ""
        case 3:
            forgotPassword = textField.text ?? ""
        case 4:
            confirmPassword = textField.text ?? ""
        default:
            break
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .numberPad
        if textField.tag == 1 {
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Login"
            textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(validateAndLogin))
        } else {
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Close"
        }
    }

    // MARK: - Set maximum character entry for login teeam number

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == .zero {
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
}
