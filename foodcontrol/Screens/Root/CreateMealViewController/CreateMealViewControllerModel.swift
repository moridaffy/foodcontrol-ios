//
//  CreateMealViewControllerModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class CreateMealViewControllerModel {
  let cellModels: [FCTableViewCellModel] = [
    MealListHeaderTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel()
  ]
}
