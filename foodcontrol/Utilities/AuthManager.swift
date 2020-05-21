//
//  AuthManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class AuthManager {
  
  static let shared = AuthManager()
  
  var isAuthorized: Bool {
    return currentUser != nil
  }
  var isAnonymous: Bool {
    return currentUser?.isAnonymous ?? false
  }
  var currentUser: User? {
    return DBManager.shared.getObjects(type: User.self, predicate: nil).first
  }
  
  func switchToAuthWorkflow() {
    guard let loginViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController() else { fatalError() }
    RootViewControllerManager.shared.change(to: loginViewController, withAnimation: .verticalDown)
  }
  
  func switchToProfileSetupWorkflow() {
    guard isAuthorized else { return }
    guard let profileSetupViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "ProfileSetupViewController") as? ProfileSetupViewController else { fatalError() }
    RootViewControllerManager.shared.change(to: profileSetupViewController, withAnimation: .verticalDown)
  }
  
  func switchToMainWorkflow() {
    guard isAuthorized else { return }
    guard let mealListViewController = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController() else { fatalError() }
    RootViewControllerManager.shared.change(to: mealListViewController, withAnimation: .verticalDown)
  }
}
