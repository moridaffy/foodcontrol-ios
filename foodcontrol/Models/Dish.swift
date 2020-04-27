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
  
  let proteinsValue: Int
  let fatsValue: Int
  let carbohydratesValue: Int
  let calloriesValue: Int
  
  init(id: String = UUID().uuidString,
       name: String,
       imageUrl: URL?,
       description: String = TestInstances.longText,
       proteinsValue: Int = Int.random(in: 0...100),
       fatsValue: Int = Int.random(in: 0...100),
       carbohydratesValue: Int = Int.random(in: 0...100),
       calloriesValue: Int = Int.random(in: 0...100)) {
    self.id = id
    self.name = name
    self.imageUrl = imageUrl
    self.description = description
    self.proteinsValue = proteinsValue
    self.fatsValue = fatsValue
    self.carbohydratesValue = carbohydratesValue
    self.calloriesValue = calloriesValue
  }
}
