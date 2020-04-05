//
//  MealListViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

protocol MealListTableViewCellModel: class { }

class MealListViewModel {
  
  let cellModels: [MealListTableViewCellModel] = [
    MealListHeaderTableViewCellModel(),
    MealListDishTableViewCellModel(),
    MealListDishTableViewCellModel(),
    MealListDishTableViewCellModel(),
    MealListHeaderTableViewCellModel(),
    MealListDishTableViewCellModel(),
    MealListDishTableViewCellModel(),
    MealListDishTableViewCellModel()
  ]
  
}
