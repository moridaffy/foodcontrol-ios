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
  
  let proteinsReference: Int
  let fatsReference: Int
  let carbohydratesReference: Int
  let calloriesReference: Int
  
  var weight: Int?
  
  init(id: String = UUID().uuidString,
       name: String,
       imageUrl: URL?,
       description: String = TestInstances.longText,
       proteinsReference: Int = Int.random(in: 0...100),
       fatsReference: Int = Int.random(in: 0...100),
       carbohydratesReference: Int = Int.random(in: 0...100),
       calloriesReference: Int = Int.random(in: 0...100)) {
    self.id = id
    self.name = name
    self.imageUrl = imageUrl
    self.description = description
    self.proteinsReference = proteinsReference
    self.fatsReference = fatsReference
    self.carbohydratesReference = carbohydratesReference
    self.calloriesReference = calloriesReference
  }
  
  func getCallories(for weight: Int? = nil) -> Int {
    return calloriesReference / 100 * (weight ?? self.weight ?? 100)
  }
}
