//
//  AppDelegate.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    FirebaseApp.configure()
    
    window?.overrideUserInterfaceStyle = .light
    
    setupRootViewController()
    
    return true
  }
  
  private func setupRootViewController() {
    guard let user = AuthManager.shared.currentUser else {
//      startAuthWorkflow()
      startProfileSetupWorkflow()
      return
    }
    
    if user.isSetup {
      startMainWorkflow()
    } else {
      startProfileSetupWorkflow()
    }
  }
  
  private func startAuthWorkflow() {
    guard let loginViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController() else { fatalError() }
    window?.rootViewController = loginViewController
  }
  
  private func startProfileSetupWorkflow() {
    guard let profileSetupViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ProfileSetupViewController") as? ProfileSetupViewController else { fatalError() }
    window?.rootViewController = profileSetupViewController
  }
  
  private func startMainWorkflow() {
    guard let mealListViewController = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController() else { fatalError() }
    window?.rootViewController = mealListViewController
  }
}

