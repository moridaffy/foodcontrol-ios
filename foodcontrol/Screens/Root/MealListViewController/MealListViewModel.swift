//
//  MealListViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class MealListViewModel {
  
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
      for dish in meal.dishes {
        cellModels.append(DishTableViewCellModel(dish: dish))
      }
    }
    self.cellModels = cellModels
  }
  
  func reloadMeals(completionHandler: @escaping (Error?) -> Void) {
    FirebaseManager.shared.getUsersMeals { [weak self] (meals, error) in
      if let meals = meals {
        self?.meals = meals
        completionHandler(nil)
      } else {
        completionHandler(error)
      }
    }
  }
  
}
