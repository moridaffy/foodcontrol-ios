//
//  Meal.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import CoreLocation

class Meal {
  let id: String
  let dateValue: String
  let coordinates: CLLocationCoordinate2D?
  let dishes: [Dish]
  
  var date: Date {
    return DateHelper().getDate(from: dateValue, ofFormat: .full) ?? Date()
  }
  var totalCallories: Double {
    var totalCallories: Double = 0
    dishes.forEach({ totalCallories += $0.getValue(for: .callories) })
    return totalCallories
  }
  
  init(id: String = UUID().uuidString,
       dateValue: String = DateHelper().getString(from: Date(), toFormat: .full),
       coordinates: CLLocationCoordinate2D? = nil,
       dishes: [Dish]) {
    self.id = id
    self.dateValue = dateValue
    self.coordinates = coordinates
    self.dishes = dishes
  }
}
