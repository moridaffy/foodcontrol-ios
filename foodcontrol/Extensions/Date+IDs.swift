//
//  Date+IDs.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

extension Date {
  var dayId: String {
    return DateHelper().getString(from: self, toFormat: .humanDayMonthYear)
  }
  var weekId: String {
    let calendar: Calendar = Calendar.current
    let week = calendar.component(.weekOfYear, from: self)
    let year = calendar.component(.year, from: self)
    return "\(week).\(year)"
  }
}
