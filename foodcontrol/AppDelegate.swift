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
    
    if AuthManager.shared.isAuthorized {
      startMainWorkflow()
    } else {
      startAuthWorkflow()
    }
    
    return true
  }
  
  private func startAuthWorkflow() {
    guard let loginViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController() else { fatalError() }
    window?.rootViewController = loginViewController
  }
  
  private func startMainWorkflow() {
    guard let mealListViewController = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController() else { fatalError() }
    window?.rootViewController = mealListViewController
  }
}

