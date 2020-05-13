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
  let text: String?
  let editable: Bool
  
  init(type: InfoType, text: String? = nil, editable: Bool = false) {
    self.type = type
    self.text = text
    self.editable = editable
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
    
    var placeholder: String {
      switch self {
      case .title:
        return NSLocalizedString("Котлеты", comment: "")
      case .description:
        return NSLocalizedString("Очень вкусные котлеты", comment: "")
      case .size:
        return NSLocalizedString("250г", comment: "")
      }
    }
  }
}
