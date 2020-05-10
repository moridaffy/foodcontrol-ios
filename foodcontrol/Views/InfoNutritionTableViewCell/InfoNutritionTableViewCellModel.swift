//
//  InfoNutritionTableViewCellModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class InfoNutritionTableViewCellModel: FCTableViewCellModel {
  
  let dish: Dish
  
  init(dish: Dish) {
    self.dish = dish
  }
  
  func getUnitValue(reference: Bool, unit: Dish.ValueType) -> Int {
    return reference ? 10 : 90
  }
}
