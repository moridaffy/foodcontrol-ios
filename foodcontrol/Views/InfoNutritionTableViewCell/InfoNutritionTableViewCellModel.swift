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
  
  func getUnitValue(reference: Bool, unit: InfoUnit) -> Int {
    return reference ? 10 : 90
  }
  
}

extension InfoNutritionTableViewCellModel {
  enum InfoUnit {
    
    static let allUnits: [InfoUnit] = [.proteins, .fats, .carbohydrates, .callories]
    
    case proteins
    case fats
    case carbohydrates
    case callories
    
    var title: String {
      switch self {
      case .proteins:
        return NSLocalizedString("Белки", comment: "")
      case .fats:
        return NSLocalizedString("Жиры", comment: "")
      case .carbohydrates:
        return NSLocalizedString("Углеводы", comment: "")
      case .callories:
        return NSLocalizedString("Каллории", comment: "")
      }
    }
    
    var unit: String {
      switch self {
      case .proteins, .fats, .carbohydrates:
        return NSLocalizedString("г", comment: "")
      case .callories:
        return NSLocalizedString("ккал", comment: "")
      }
    }
  }
}
