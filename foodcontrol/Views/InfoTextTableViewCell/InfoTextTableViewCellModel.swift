//
//  InfoTextTableViewCellModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class InfoTextTableViewCellModel: FCTableViewCellModel {
  let type: InfoType
  let text: String
  
  init(type: InfoType, text: String) {
    self.type = type
    self.text = text
  }
}

extension InfoTextTableViewCellModel {
  enum InfoType {
    case title
    case description
    case size
    
    var title: String {
      switch self {
      case .title:
        return NSLocalizedString("Название", comment: "")
      case .description:
        return NSLocalizedString("Описание", comment: "")
      case .size:
        return NSLocalizedString("Размер порции", comment: "")
      }
    }
  }
}