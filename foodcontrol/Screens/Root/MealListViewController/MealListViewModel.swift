//
//  MealListViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class MealListViewModel {
  
  let cellModels: [FCTableViewCellModel] = [
    MealHeaderTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel(),
    MealHeaderTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel()
  ]
  
}
