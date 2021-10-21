//
//  RegistrationViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 20/10/2021.
//

import UIKit

class RegistrationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(nil, forKey: "isRegistered")
        UserDefaults.standard.setValue(false, forKey: "isRegistered")
        setupTitleAndBackButtonView(title: "Registration", isBackButton: false)
        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
