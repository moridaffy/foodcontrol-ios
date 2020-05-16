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
  let editable: Bool
  
  init(dish: Dish, editable: Bool = false) {
    self.dish = dish
    self.editable = editable
  }
}
