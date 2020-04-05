//
//  BigButtonTableViewCellModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class BigButtonTableViewCellModel: FCTableViewCellModel {
  
  let type: ButtonType
  
  init(type: ButtonType) {
    self.type = type
  }
  
}

extension BigButtonTableViewCellModel {
  enum ButtonType {
    case addDish
    case createDish
    case addImage
    
    var height: Double {
      switch self {
      case .addDish:
        return 108.0
      case .createDish:
        return 108.0
      case .addImage:
        return 199.0
      }
    }
    
    var title: String {
      switch self {
      case .addDish:
        return NSLocalizedString("Добавить блюдо", comment: "")
      case .createDish:
        return NSLocalizedString("Создать блюдо", comment: "")
      case .addImage:
        return NSLocalizedString("Добавить фото", comment: "")
      }
    }
    
    var iconName: String {
      switch self {
      case .addDish:
        return "plus.circle.fill"
      case .createDish:
        return "plus.circle.fill"
      case .addImage:
        return "camera.circle.fill"
      }
    }
  }
}
