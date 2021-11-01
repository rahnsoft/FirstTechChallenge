//
//  ViewController.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 11/10/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    // Initialize the welcomeView
    lazy var welcomeView: WelcomeView = {
        let v = WelcomeView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Hide the status bar on Splash Screen

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Setup the welcomeView and animations for the splash screens

    func setupViews() {
        view.backgroundColor = .themeColor
        view.addSubview(welcomeView)
        welcomeView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        welcomeView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        welcomeView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        welcomeView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        UIView.animate(withDuration: 0.7, delay: 0.3, animations: { [self] in
            welcomeView.ftcLogo.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            welcomeView.ffLogo.alpha = 0
        }) { [self] _ in
            UIView.animate(withDuration: 0.7, animations: { [self] in
                welcomeView.ftcLogo.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                welcomeView.ffLogo.alpha = 0
                welcomeView.ffLogo.transform = CGAffineTransform(translationX: 0, y: welcomeView.ftcLogo.frame.origin.y)
            }) { [self] _ in
                UIView.animate(withDuration: 0.7, animations: { [self] in
                    welcomeView.ffLogo.isHidden = false
                    welcomeView.ftcLogo.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                }) { _ in
                    UIView.animate(withDuration: 1.0, animations: { [self] in
                        welcomeView.ftcLogo.transform = CGAffineTransform.identity
                        welcomeView.ffLogo.alpha = 1
                        welcomeView.ffLogo.transform = CGAffineTransform.identity
                    }) { _ in
                        delay(0.5) {
                            UIView.transition(with: (appDelegate?.window)!, duration: 0.7, options: .transitionFlipFromLeft) {
                                initialSetup()
                            } completion: { _ in }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Make Registration Controller the rootViewController

    func initialSetup() {
        let controller = UINavigationController(rootViewController: LoginViewController())
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = .fromLeft
        controller.view.layer.add(transition, forKey: "kCATransition")
        appDelegate?.makeRootViewController(controller)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
