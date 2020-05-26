//
//  MealListViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class MealListViewModel {
  
  private(set) var isLoading: Bool = false {
    didSet {
      view?.updateActivityIndicator(animating: isLoading)
    }
  }
  private(set) var meals: [Meal] = [] {
    didSet {
      reloadCellModels()
    }
  }
  private(set) var cellModels: [FCTableViewCellModel] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: MealListViewController?
  
  private func reloadCellModels() {
    var cellModels: [FCTableViewCellModel] = []
    for meal in meals.sorted(by: { $0.date > $1.date }) {
      cellModels.append(MealHeaderTableViewCellModel(meal: meal))
      for dish in meal.dishes.sorted(by: { $0.id > $1.id }) {
        cellModels.append(DishTableViewCellModel(dish: dish))
      }
    }
    self.cellModels = cellModels
  }
  
  func reloadMeals(completionHandler: @escaping (Error?) -> Void) {
    guard !AuthManager.shared.isAnonymous else {
      meals = []
      completionHandler(nil)
      return
    }
    isLoading = true
    FirebaseManager.shared.getUsersMeals { [weak self] (meals, error) in
      self?.isLoading = false
      if let meals = meals {
        self?.meals = meals
        completionHandler(nil)
      } else {
        completionHandler(error)
      }
    }
  }
}
