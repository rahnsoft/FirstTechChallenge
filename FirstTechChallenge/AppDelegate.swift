//
//  AppDelegate.swift
//  FirstTechChallenge
//
//  Created by IOS DEV PRO 1 on 11/10/2021.
//

import CoreData
import IQKeyboardManagerSwift
import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        window = UIWindow(frame: UIScreen.main.bounds)
        checkLogin()
        return true
    }

    func checkLogin() {
        let nav1 = UINavigationController(rootViewController: WelcomeViewController())
        let nav2 = UINavigationController(rootViewController: stage1ViewController())
        let nav3 = UINavigationController(rootViewController: FeedBackViewController())
        APIHelper.shared.fetchLoginDetails { _ in }
        if APIHelper.shared.getSavedTeam() != nil {
            makeRootViewController(nav2)
        } else {
            makeRootViewController(nav1)
        }
        window?.makeKeyAndVisible()
    }

    // MARK: - Make rootViewController

    func makeRootViewController(_ viewController: UIViewController?, withAnimation: Bool = false) {
        if withAnimation {
            UIView.transition(with: (appDelegate?.window)!, duration: 0.7, options: .transitionFlipFromRight) {
                self.window?.rootViewController = viewController
            }
        } else {
            window?.rootViewController = viewController
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
          The persistent container for the application. This implementation
          creates and returns a container, having loaded the store for the
          application to it. This property is optional since there are legitimate
          error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FirstTechChallenge")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
