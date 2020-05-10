//
//  Dish.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class Dish {
  let id: String
  let name: String
  let imageUrl: URL?
  let description: String
  
  let proteinsReference: Double
  let fatsReference: Double
  let carbohydratesReference: Double
  let calloriesReference: Double
  
  var weight: Double?
  
  init(id: String = UUID().uuidString,
       name: String,
       imageUrl: URL?,
       description: String = TestInstances.longText,
       proteinsReference: Double = Double.random(in: 0...100),
       fatsReference: Double = Double.random(in: 0...100),
       carbohydratesReference: Double = Double.random(in: 0...100),
       calloriesReference: Double = Double.random(in: 0...100)) {
    self.id = id
    self.name = name
    self.imageUrl = imageUrl
    self.description = description
    self.proteinsReference = proteinsReference
    self.fatsReference = fatsReference
    self.carbohydratesReference = carbohydratesReference
    self.calloriesReference = calloriesReference
  }
  
  func getValue(for type: ValueType, weight: Double? = nil) -> Double {
    let weight = weight ?? 100
    switch type {
    case .proteins:
      return proteinsReference * weight
    case .fats:
      return fatsReference * weight
    case .carbohydrates:
      return carbohydratesReference * weight
    case .callories:
      return calloriesReference * weight
    }
  }
}

extension Dish {
  enum ValueType {
    
    static let allUnits: [ValueType] = [.proteins, .fats, .carbohydrates, .callories]
    
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
