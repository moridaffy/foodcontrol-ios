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
    return !DBManager.shared.getObjects(type: User.self, predicate: nil).isEmpty
  }
  
  func switchToAuthWorkflow() {
    guard let loginViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController() else { fatalError() }
    RootViewControllerManager.shared.change(to: loginViewController, withAnimation: .verticalDown)
  }
  
  func switchToMainWorkflow() {
    guard isAuthorized else { return }
    guard let mealListViewController = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController() else { fatalError() }
    RootViewControllerManager.shared.change(to: mealListViewController, withAnimation: .verticalDown)
  }
  
}
