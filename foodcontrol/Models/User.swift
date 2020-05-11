//
//  User.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var surname: String = ""
  @objc dynamic var weightPlanValue: Int = 0
  
  @objc dynamic var vkId: String = ""
  
  var weightPlan: WeightPlanType {
    return WeightPlanType(rawValue: weightPlanValue) ?? .unknown
  }
  var vkLinked: Bool {
    return !vkId.isEmpty
  }
  
  convenience init(id: String, name: String, surname: String, vkId: String? = nil) {
    self.init()
    self.id = id
    self.name = name
    self.surname = surname
    self.vkId = vkId ?? ""
  }
}

extension User {
  enum WeightPlanType: Int {
    case unknown
    case loseWeight = 1
    case keepWeight = 2
    case gainWeight = 3
    
    var title: String {
      switch self {
      case .loseWeight:
        return NSLocalizedString("Сбросить", comment: "")
      case .keepWeight:
        return NSLocalizedString("Поддерживать", comment: "")
      case .gainWeight:
        return NSLocalizedString("Набрать", comment: "")
      default:
        return NSLocalizedString("Неизвестно", comment: "") + ": \(self.rawValue)"
      }
    }
  }
}
