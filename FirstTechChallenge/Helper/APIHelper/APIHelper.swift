//
//  APIHelper.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 18/10/2021.
//

import CoreData
import Foundation
import UIKit

protocol ImageUploaded {
    func imageUploaded()
}

let appDelegate = UIApplication.shared.delegate as? AppDelegate
func delay(_ delay: Double, closure: @escaping () -> ()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

final class APIHelper: NSObject {
    var delegate: ImageUploaded?
    var registrationTeamDetails: TeamDetails?
    var loginTeamDetails: TeamLoginDetails?
    var teamScores: [TeamScores]?
    var isLoggedIn = false
    var isFromFeedBack = true
    static let shared = APIHelper()
    static let appFontName = "Poppins-Regular"
    static let appBoldFontName = "Poppins-Bold"
    static let appMediumName = "Poppins-Medium"
    static let appTilteBoldFontName = "Poppins-ExtraBold"
    static let appSemiBoldFontName = "Poppins-SemiBold"

    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var profileImage = UIImage()

    /// Get profileImage file url
    func imageURL() -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("teamImage.png") else { return URL(string: "")! }
        return url
    }

    /// Save chosen image to a local file
    func saveImage(image: UIImage) {
        guard let imgData = image.pngData() else { return }
        do {
            try imgData.write(to: imageURL())
            _ = getImage()
            delegate?.imageUploaded()
        } catch {
            ErrorToast("Couldnt save yoour image.Please try again!")
        }
    }

    /// Get profileImage from saved file
    func getImage() -> UIImage {
        return UIImage(contentsOfFile: imageURL().path) ?? #imageLiteral(resourceName: "icon-placeholder-image").withRenderingMode(.alwaysTemplate)
    }

    /// Register a team
    func registerTeam(teamModel: TeamRegistrationModel, completion: @escaping (Bool, String) -> ()) {
        let team = TeamDetails(context: context!)
        team.teamName = teamModel.teamName
        team.teamNumber = teamModel.teamNumber
        team.teamRobotName = teamModel.teamRobotName
        team.teamRegion = teamModel.teamRegion
        team.teamPassword = teamModel.teamPassword
        team.isShareDetails = teamModel.isShareDetails
        saveContext { success, message in
            if success {
                completion(true, message)
            } else {
                completion(false, message)
            }
        }
    }

    /// Save persistent container context
    func saveContext(_ isSucces: @escaping (Bool, String) -> ()) {
        if context!.hasChanges {
            do {
                try context?.save()
                isSucces(true, "Success")
            } catch {
                isSucces(false, error.localizedDescription)
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo) error: \(error.localizedDescription)")
            }
        }
    }

    /// Delete a team
    func deleteTeam(success: @escaping (Bool, String) -> ()) {
        let request: NSFetchRequest<TeamLoginDetails> = TeamLoginDetails.fetchRequest()
        do {
            let objects = try! context?.fetch(request)
            if let details = objects {
                for obj in details {
                    context?.delete(obj)
                }
            }
            try context?.save()
            success(true, "Team loggged out")
        } catch {
            success(false, error.localizedDescription)
            debugPrint("Team loggged out: \(error.localizedDescription)")
        }
    }

    /// Login a team
    func saveLoginDetails(_ isLogginSuccess: @escaping (Bool, String) -> ()) {
        deleteTeam { _, _ in }
        let loginDetails = TeamLoginDetails(context: context!)
        loginDetails.loginTeamName = registrationTeamDetails?.teamName
        loginDetails.loginTeamNumber = registrationTeamDetails?.teamNumber
        loginDetails.loginRobotName = registrationTeamDetails?.teamRobotName
        loginDetails.loginTeamRegion = registrationTeamDetails?.teamRegion
        loginDetails.loginPassword = registrationTeamDetails?.teamPassword
        loginDetails.isShareDetails = registrationTeamDetails?.isShareDetails ?? false
        saveContext { success, message in
            if success {
                self.loginTeamDetails = loginDetails
                isLogginSuccess(true, message)
            } else {
                isLogginSuccess(false, message)
            }
        }
    }

    // Login team with API
    func saveLoginDetailsApi(loginTeamName: String, loginTeamNumber: String, loginRobotName: String = "Not set", loginTeamRegion: String = "Not set", loginPassword: String = "000000", isShareDetails: Bool = false, _ isLogginSuccess: @escaping (Bool, String) -> ()) {
        let loginDetails = TeamLoginDetails(context: context!)
        loginDetails.loginTeamName = loginTeamName
        loginDetails.loginTeamNumber = loginTeamNumber
        loginDetails.loginRobotName = loginRobotName
        loginDetails.loginTeamRegion = loginTeamRegion
        loginDetails.loginPassword = loginPassword
        loginDetails.isShareDetails = isShareDetails
        saveContext { success, message in
            if success {
                self.loginTeamDetails = loginDetails
                isLogginSuccess(true, message)
            } else {
                isLogginSuccess(false, message)
            }
        }
    }

    /// Fetch a teams registration details
    func fetchRegistrationDetails(teamNumber: String? = nil, isLogginSuccess: @escaping (Bool) -> ()) {
        let request: NSFetchRequest<TeamDetails> = TeamDetails.fetchRequest()
        if teamNumber != nil {
            let predicateContains = NSPredicate(format: "teamNumber CONTAINS[cd] %@", teamNumber!)
            let predicateMatches = NSPredicate(format: "teamNumber MATCHES %@", teamNumber!)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateContains, predicateMatches])
        }
        do {
            registrationTeamDetails = try context?.fetch(request).last
            isLogginSuccess(true)
        } catch {
            isLogginSuccess(false)
            debugPrint("error: \(error.localizedDescription)")
        }
    }

    func setUser(user: TeamLoginDetails?) {
        loginTeamDetails = user
    }

    /// Get the saved team
    func getSavedTeam() -> TeamLoginDetails? {
        return loginTeamDetails
    }

    func setTeamScores(score: [TeamScores]?) {
        teamScores = score
    }

    /// Get the saved team
    func getSavedTeamScores() -> [TeamScores]? {
        return teamScores
    }

    /// Fetch the loginDetails of the team
    func fetchLoginDetails(isLogginSuccess: @escaping (Bool) -> ()) {
        let request: NSFetchRequest<TeamLoginDetails> = TeamLoginDetails.fetchRequest()
        do {
            setUser(user: try context?.fetch(request).first)
            isLogginSuccess(true)
        } catch {
            isLogginSuccess(false)
            debugPrint("error: \(error.localizedDescription)")
        }
    }

    /// Change the passowrd of the team registration details
    func changePassword(teamNumber: String?, newPassword: String, success: @escaping (Bool) -> ()) {
        let request: NSFetchRequest<TeamDetails> = TeamDetails.fetchRequest()
        if teamNumber != nil {
            let predicateContains = NSPredicate(format: "teamNumber CONTAINS[cd] %@", teamNumber!)
            let predicateMatches = NSPredicate(format: "teamNumber MATCHES %@", teamNumber!)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateContains, predicateMatches])
        }
        do {
            registrationTeamDetails = try context?.fetch(request).last
            registrationTeamDetails?.teamPassword = newPassword
            saveContext { _, _ in }
            success(true)
            changePasswordLogin(newPassword: newPassword)
        } catch {
            ErrorToast("Team number does not exist")
            success(false)
        }
    }

    /// Change the passowrd of the team login details
    func changePasswordLogin(newPassword: String) {
        let request: NSFetchRequest<TeamLoginDetails> = TeamLoginDetails.fetchRequest()
        let predicateContains = NSPredicate(format: "loginTeamNumber CONTAINS[cd] %@", (getSavedTeam()?.loginTeamNumber)!)
        let predicateMatches = NSPredicate(format: "loginTeamNumber MATCHES %@", (getSavedTeam()?.loginTeamNumber)!)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateContains, predicateMatches])
        do {
            loginTeamDetails = try context?.fetch(request).last
            loginTeamDetails?.loginPassword = newPassword
            saveContext { _, _ in }
        } catch {
            ErrorToast("Team number does not exist")
        }
    }

    /// Change the sharedetails boolean for lohin data
    func changeShareDetails(isShareDetails: Bool = false, success: @escaping (Bool) -> ()) {
        let request: NSFetchRequest<TeamDetails> = TeamDetails.fetchRequest()
        let predicateContains = NSPredicate(format: "teamNumber CONTAINS[cd] %@", (getSavedTeam()?.loginTeamNumber)!)
        let predicateMatches = NSPredicate(format: "teamNumber MATCHES %@", (getSavedTeam()?.loginTeamNumber)!)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateContains, predicateMatches])
        do {
            registrationTeamDetails = try context?.fetch(request).last
            registrationTeamDetails?.isShareDetails = isShareDetails
            saveContext { _, _ in }
            success(true)
            changeShareDetailsRegistration(isShareDetails: isShareDetails)
        } catch {
            ErrorToast("Team number does not exist")
            success(false)
        }
    }

    /// Change the sharedetails boolean for registration data
    func changeShareDetailsRegistration(isShareDetails: Bool = false) {
        let request: NSFetchRequest<TeamLoginDetails> = TeamLoginDetails.fetchRequest()
        let predicateContains = NSPredicate(format: "loginTeamNumber CONTAINS[cd] %@", (getSavedTeam()?.loginTeamNumber)!)
        let predicateMatches = NSPredicate(format: "loginTeamNumber MATCHES %@", (getSavedTeam()?.loginTeamNumber)!)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateContains, predicateMatches])
        do {
            loginTeamDetails = try context?.fetch(request).last
            loginTeamDetails?.isShareDetails = isShareDetails
            saveContext { _, _ in }
            _ = getSavedTeam()
        } catch {}
    }

    func saveScoreDetails(teamNumber: String, stage1: String = HavaConstants.stage1Score.description, stage2: String = HavaConstants.stage2Score.description, stage3: String = HavaConstants.stage3Score.description, totalScore: String = (HavaConstants.stage1Score + HavaConstants.stage2Score + HavaConstants.stage3Score).description, created: String = Date().getCurrentDate, scoreRound: String = HavaConstants.scoreRound.description, location: String, completion: @escaping (Bool, String) -> ()) {
        let score = TeamScores(context: context!)
        score.scoreTeamNumber = teamNumber
        score.stage1Score = stage1
        score.stage2Score = stage2
        score.stage3Score = stage3
        score.totalScore = totalScore
        score.createdAt = created
        score.round = scoreRound
        score.scoreLocation = location
        saveContext { success, message in
            if success {
                completion(true, message)
            } else {
                completion(false, message)
            }
        }
    }

    func fetchScoreDetails(_ teamNumber: String, completion: @escaping (Bool) -> ()) {
        let request: NSFetchRequest<TeamScores> = TeamScores.fetchRequest()
        request.predicate = NSPredicate(format: "scoreTeamNumber MATCHES %@", (getSavedTeam()?.loginTeamNumber)!)
        do {
            setTeamScores(score: try context?.fetch(request))
            _ = getSavedTeamScores()
            completion(true)
        } catch {
            completion(true)
            ErrorToast(error.localizedDescription)
        }
    }

    func fetchScoreDetailsAll(completion: @escaping (Bool) -> ()) {
        let request: NSFetchRequest<TeamScores> = TeamScores.fetchRequest()
        do {
            setTeamScores(score: try context?.fetch(request))
            _ = getSavedTeamScores()
            completion(true)
        } catch {
            completion(true)
            ErrorToast(error.localizedDescription)
        }
    }
}

extension APIHelper {
    func getAllScores(_ completion: @escaping (_ result: [TeamScore], _ message: Error?) -> ()) {
        let task = URLSession(configuration: .default).dataTask(with: URL(string: HavaConstants.allScoresUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!) { data, _, error in
            DispatchQueue.main.async {
                if error == nil {
                    if let responseData = data {
                        let decoder = JSONDecoder()
                        do {
                            let action = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject]
                            let result = action?["result"] as? String
                            if result?.lowercased() != "error".lowercased() {
                                let data = try decoder.decode([TeamScore].self, from: responseData)
                                completion(data, error)
                            } else {
                                ErrorToast("Incorrect team Number")
                            }
                        } catch {
                            completion([TeamScore](), error)
                        }
                    }
                    UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
                } else {
                    ErrorToast(error!.localizedDescription)
                }
                UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
            }
        }
        task.resume()
    }

    func getAllTeams(_ completion: @escaping (_ result: [Team], _ message: Error?) -> ()) {
        let task = URLSession(configuration: .default).dataTask(with: URL(string: HavaConstants.allTeamUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!) { data, _, error in
            DispatchQueue.main.async {
                if error == nil {
                    if let responseData = data {
                        let decoder = JSONDecoder()
                        do {
                            let action = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject]
                            let result = action?["result"] as? String
                            if result?.lowercased() != "error".lowercased() {
                                let data = try decoder.decode([Team].self, from: responseData)
                                completion(data, error)
                            } else {
                                ErrorToast("Incorrect team Number")
                            }
                        } catch {
                            completion([Team](), error)
                            ErrorToast(error.localizedDescription)
                        }
                    }
                } else {
                    ErrorToast(error!.localizedDescription)
                }
            }
        }
        task.resume()
    }

    func createTeam(teamid: String, name: String, location: String, completion: @escaping (_ result: Data?, _ error: Error?) -> ()) {
        let url = String(format: HavaConstants.createTeam, teamid, name, location).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let task = URLSession(configuration: .default).dataTask(with: URL(string: url)!) { data, _, error in
            DispatchQueue.main.async {
                if error == nil {
                    if let responseData = data {
                        completion(responseData, error)
                    }
                } else {
                    ErrorToast(error!.localizedDescription)
                }
            }
        }
        task.resume()
    }

    func getSingleTeam(teamid: String, completion: @escaping (_ result: Team?, _ error: Error?) -> ()) {
        UIApplication.shared.keyWindow?.startBlockingActivityIndicator()
        let url = String(format: HavaConstants.singleTeam, teamid).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let task = URLSession(configuration: .default).dataTask(with: URL(string: url)!) { data, _, error in
            DispatchQueue.main.async {
                if error == nil {
                    if let responseData = data {
                        let decoder = JSONDecoder()
                        do {
                            let action = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: AnyObject]
                            let result = action?["result"] as? String
                            if result?.lowercased() != "error".lowercased() {
                                let data = try decoder.decode(Team.self, from: responseData)
                                completion(data, error)
                            } else {
                                ErrorToast("Incorrect team Number")
                            }
                        } catch {
                            completion(Team(), error)
                            ErrorToast(error.localizedDescription)
                        }
                    }
                    UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
                } else {
                    ErrorToast(error!.localizedDescription)
                }
                UIApplication.shared.keyWindow?.stopBlockingActivityIndicator()
            }
        }
        task.resume()
    }

    func submitScore(teamid: String, autonomous: String?, drivercontrolled: String?, endgame: String?, location: String?, completion: @escaping (_ result: Data?, _ error: Error?) -> ()) {
        let url = String(format: HavaConstants.submitScore, teamid, autonomous ?? "", drivercontrolled ?? "", endgame ?? "", location ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let task = URLSession(configuration: .default).dataTask(with: URL(string: url)!) { data, _, error in
            DispatchQueue.main.async {
                if error == nil {
                    if let responseData = data {
                        completion(responseData, error)
                    }
                } else {
                    ErrorToast(error!.localizedDescription)
                }
            }
        }
        task.resume()
    }
}

extension Date {
    func getDateFromString(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateString) ?? Date()
    }

    var getCurrentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
