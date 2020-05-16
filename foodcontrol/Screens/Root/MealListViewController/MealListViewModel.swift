//
//  MealListViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class MealListViewModel {
  
  private(set) var cellModels: [FCTableViewCellModel] = []
  
  private func refreshCellModels(for meals: [Meal]) {
    var cellModels: [FCTableViewCellModel] = []
    for meal in meals {
      cellModels.append(MealHeaderTableViewCellModel(meal: meal))
      for dish in meal.dishes {
        cellModels.append(DishTableViewCellModel(dish: dish))
      }
    }
    self.cellModels = cellModels
  }
  
}
