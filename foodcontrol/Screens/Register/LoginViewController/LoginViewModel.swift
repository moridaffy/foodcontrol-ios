//
//  LoginViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class LoginViewModel {
  
  func login(email: String, password: String, completionHandler: (Bool, Error?) -> Void) {
    // TODO: сетевой запрос
    // TODO: проверка заполненности профиля
    completionHandler(true, nil)
    if true {
      AuthManager.shared.switchToProfileSetupWorkflow()
    } else {
      AuthManager.shared.switchToMainWorkflow()
    }
  }
  
}
