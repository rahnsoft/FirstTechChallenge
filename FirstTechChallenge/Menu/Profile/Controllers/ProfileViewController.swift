//
//  ProfileViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 28/10/2021.
//
import IQKeyboardManagerSwift
import UIKit

final class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    lazy var picker: UIImagePickerController = {
        let iv = UIImagePickerController()
        iv.allowsEditing = false
        iv.delegate = self
        iv.modalPresentationStyle = .fullScreen
        return iv
    }()

    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .singleLine
        tv.backgroundColor = .paleGray
        tv.estimatedRowHeight = 50
        tv.rowHeight = UITableView.automaticDimension
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    lazy var profileHeader: ProfileHeaderView = {
        let header = ProfileHeaderView()
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(proPicPressed)))
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    lazy var signoutView: SignOutView = {
        let iv = SignOutView()
        iv.confirmButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return iv
    }()

    var teamNumberTextField = UITextField()
    var passTextfield = UITextField()
    var confirmPassTextfield = UITextField()
    var loginTeamNumber = ""
    var loginPassword = ""
    var forgotTeamNumber = ""
    var forgotPassword = ""
    var confirmPassword = ""
    var hasShownModal: Bool = false

    lazy var showShareModal: ConfirmCancelView = {
        let v = ConfirmCancelView()
        return v
    }()

    typealias ProfileItem = (key: String?, placeHolder: String?, value: String?, isEnable: Bool, fieldName: String, fieldType: ProfileField)
    typealias ProfileDetail = (title: String, items: [ProfileItem])
    private(set) var profileItems = [ProfileDetail]()
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themeColor
        setupDataSourceItems()
        view.addSubview(tableView)
        setupTitleAndRightButtonView(title: "Profile", isProfile: false)
        setupTitleAndBackButtonView(title: "Home", isBackAnimation: false)
        setNeedsStatusBarAppearanceUpdate()
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        tableView.register(ProfileEditCell.self, forCellReuseIdentifier: ProfileEditCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIHelper.shared.fetchLoginDetails { _ in }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        signoutView.cancel(self)
    }

    func setupDataSourceItems() {
        profileItems.removeAll()
        let user = APIHelper.shared.loginTeamDetails
        var newItems = [ProfileItem]()
        let nameItem = ProfileItem("Team Name", placeHolder: "not set", user?.loginTeamName, false, fieldName: ProfileField.teamName.value, fieldType: .teamName)
        newItems.append(nameItem)
        let teamNumber = ProfileItem("Team Number", placeHolder: "not set", user?.loginTeamNumber, false, fieldName: ProfileField.teamNumber.value, fieldType: .teamNumber)
        newItems.append(teamNumber)
        let loginRobotName = ProfileItem("Robot Name", placeHolder: "not set", user?.loginRobotName, false, fieldName: ProfileField.robotName.rawValue, fieldType: .robotName)
        newItems.append(loginRobotName)
        let loginTeamRegion = ProfileItem("Region", placeHolder: "not set", user?.loginTeamRegion, false, fieldName: ProfileField.region.rawValue, fieldType: .region)
        newItems.append(loginTeamRegion)
        let password = ProfileItem("", placeHolder: "not set", "Change password", true, fieldName: "", fieldType: .password)
        newItems.append(password)
        let shareDetails = ProfileItem("", placeHolder: "not set", "Share team details", true, fieldName: "", fieldType: .shareDetails)
        newItems.append(shareDetails)
        let mainItem = ProfileDetail("text_basic_settings", newItems)
        profileItems.append(mainItem)
        profileHeader.profilePic.image = APIHelper.shared.getImage()

        // MARK: SignOut Details

        var signOutItems = [ProfileItem]()
        let signoutItem = ProfileItem("Sign Out", placeHolder: "not set", "Sign out", false, fieldName: "", fieldType: .signout)
        signOutItems.append(signoutItem)
        let mainSignoutItem = ProfileDetail("", signOutItems)
        profileItems.append(mainSignoutItem)
    }

    @objc fileprivate func logout() {
        APIHelper.shared.deleteTeam { success, message in
            if success {
                let nav = UINavigationController(rootViewController: LoginViewController())
                appDelegate?.makeRootViewController(nav, withAnimation: true)
                SuccessToast(message)
            } else {
                ErrorToast(message)
            }
        }
        signoutView.cancel(self)
    }

    // Show an alert to change the password
    @objc func changePassword() {
        let user = APIHelper.shared.loginTeamDetails
        let forgotPasswordAlert = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)

        forgotPasswordAlert.addTextField { [self] numberTextField in
            numberTextField.placeholder = "Enter team Number"
            teamNumberTextField = numberTextField
            teamNumberTextField.delegate = self
            teamNumberTextField.tag = 0
            teamNumberTextField.text = user?.loginTeamNumber
            teamNumberTextField.isUserInteractionEnabled = false
        }

        forgotPasswordAlert.addTextField { [self] passwordTextField in
            passwordTextField.placeholder = "Enter password"
            passTextfield = passwordTextField
            passTextfield.delegate = self
            passTextfield.tag = 1
            passTextfield.becomeFirstResponder()
        }

        forgotPasswordAlert.addTextField { [self] confirmTextField in
            confirmTextField.placeholder = "Confirm password"
            confirmPassTextfield = confirmTextField
            confirmPassTextfield.delegate = self
            confirmPassTextfield.tag = 2
        }

        // Action to change the password after validation
        let updateAction = UIAlertAction(title: "Submit", style: .default) { [self] _ in
            if forgotPassword.isEmpty || forgotPassword.count < 6 {
                WarningToast("Password can not be empty or less than 6 characters")

            } else if confirmPassword.isEmpty || confirmPassword.count < 6 {
                WarningToast("Confirm password can not be empty or less than 6 characters")

            } else if confirmPassword != forgotPassword {
                ErrorToast("Confirm password didn't match!")
            } else {
                APIHelper.shared.fetchRegistrationDetails(teamNumber: user?.loginTeamNumber) { success in
                    if success {
                        if APIHelper.shared.registrationTeamDetails?.teamNumber == nil {
                            ErrorToast("Team does not exist")
                        } else if APIHelper.shared.registrationTeamDetails?.teamNumber == user?.loginTeamNumber {
                            APIHelper.shared.changePassword(teamNumber: user?.loginTeamNumber, newPassword: confirmPassword) { success in
                                if success {
                                    SuccessToast("Password changed successfully")
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
        }
    }

    @objc func yesShareDetails() {
        dismiss(animated: true) {
            APIHelper.shared.changeShareDetails(isShareDetails: true, success: { _ in SuccessToast("Success: Share details") })
        }
    }

    @objc func dontShareDetails() {
        hasShownModal = false
        dismiss(animated: true, completion: nil)
    }

    @objc func shareDetails() {
        let shareDetailsAlert = UIAlertController(title: "Share Team Details", message: "Do you want to share your team details and scores with other teams? ", preferredStyle: .actionSheet)
        let yes = UIAlertAction(title: "Yes", style: .default) { [self] _ in
            if !hasShownModal {
                hasShownModal = true
                showShareModal.coverImage.image = #imageLiteral(resourceName: "image-share-referral")
                showShareModal.label.text = "By continuing, the team details and scores will be sent to our servers and made accessible to other teams. Do you wish to continue?"
                showShareModal.show()
                showShareModal.confirmButton.addTarget(self, action: #selector(yesShareDetails), for: .touchUpInside)
                showShareModal.cancelButton.addTarget(self, action: #selector(dontShareDetails), for: .touchUpInside)
            }
        }
        shareDetailsAlert.addAction(yes)
        let no = UIAlertAction(title: "No", style: .default) { _ in
            self.dismiss(animated: true) {
                APIHelper.shared.changeShareDetails(isShareDetails: false, success: { _ in SuccessToast("Success: Don't share details") })
            }
        }
        shareDetailsAlert.addAction(no)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        shareDetailsAlert.addAction(cancel)
        present(shareDetailsAlert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = profileItems[indexPath.section].items[indexPath.item]
        switch item.fieldType {
        case .teamName, .teamNumber, .robotName, .region, .password, .shareDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileEditCell.identifier, for: indexPath) as? ProfileEditCell ?? ProfileEditCell()
            cell.header.text = item.key
            cell.field.text = item.value
            cell.field.placeholder = item.placeHolder
            cell.chevronImage.isHidden = !item.isEnable
            return cell
        case .signout:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
            cell.backgroundColor = .white
            cell.contentView.backgroundColor = .white
            cell.selectionStyle = .none
            cell.textLabel?.text = item.value
            cell.textLabel?.textColor = .red
            cell.textLabel?.font = UIFont.appFont(ofSize: HavaConstants.LARGE_FONT_SIZE)
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == .zero {
            let containerView = UIView()
            containerView.backgroundColor = .paleGray
            containerView.addSubview(profileHeader)
            profileHeader.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            profileHeader.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            profileHeader.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            profileHeader.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            return containerView
        }
        let headerLabel = UILabel()
        headerLabel.font = UIFont.appMediumFont(ofSize: 14)
        headerLabel.textColor = .lightGray
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        let section = profileItems[section]
        headerLabel.text = section.title
        let containerView = UIView()
        containerView.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: HavaConstants.DEFAULT_PADDING).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -HavaConstants.DEFAULT_PADDING).isActive = true
        return containerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = profileItems[indexPath.section].items[indexPath.item]
        switch item.fieldType {
        case .password:
            changePassword()
        case .teamName, .teamNumber, .robotName, .region: break
        case .signout:
            signoutView.show()
        case .shareDetails:
            shareDetails()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            forgotPassword = textField.text ?? ""
        case 2:
            confirmPassword = textField.text ?? ""
        default:
            break
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = .numberPad
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
