//
//  MealHeaderTableViewCellModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class MealHeaderTableViewCellModel: FCTableViewCellModel {
  
  let meal: Meal
  
  init(meal: Meal) {
    self.meal = meal
  }
  
  var dateDayMonthString: String {
    return DateHelper().getString(from: meal.date, toFormat: .humanDayMonth)
  }
  var dateTimeString: String {
    return DateHelper().getString(from: meal.date, toFormat: .humanTime)
  }
  
}
