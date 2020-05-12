//
//  LoginViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class LoginViewModel {
  
  func login(email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
    FirebaseManager.shared.login(email: email, password: password) { (user, error) in
      if let user = user {
        DBManager.shared.saveObject(user)
        completionHandler(true, nil)
        if user.isSetup {
          AuthManager.shared.switchToMainWorkflow()
        } else {
          AuthManager.shared.switchToProfileSetupWorkflow()
        }
      } else {
        completionHandler(false, error)
      }
    }
  }
  
}
