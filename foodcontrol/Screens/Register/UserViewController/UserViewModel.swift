//
//  ProfileViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class UserViewModel {
  
  let user: User
  private(set) var meals: [Meal] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: UserViewController?
  
  init(user: User, meals: [Meal]? = nil) {
    self.user = user
    self.meals = meals ?? []
    
    if meals == nil {
      getUsersMeals()
    }
  }
  
  private func getUsersMeals() {
    FirebaseManager.shared.getUsersMeals(userId: user.id) { [weak self] (meals, error) in
      if let meals = meals {
        self?.meals = meals
      } else {
        self?.view?.showAlertError(error: error,
                                   desc: NSLocalizedString("Не удалось загрузить информацию о пользователе", comment: ""),
                                   critical: false)
      }
    }
  }
  
  func logout() {
    DBManager.shared.deleteAll()
    AuthManager.shared.switchToAuthWorkflow()
  }
}
