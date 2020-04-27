//
//  DateHelper.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class DateHelper {
  func getDate(from input: String, ofFormat format: DateFormat) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.dateFormat
    
    let date = dateFormatter.date(from: input)
    return date
  }
  
  func getString(from input: String, ofFormat inputFormat: DateFormat, toFormat outputFormat: DateFormat) -> String? {
    guard let inputDate = getDate(from: input, ofFormat: inputFormat) else { return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = outputFormat.dateFormat
    return dateFormatter.string(from: inputDate)
  }
  
  func getString(from input: Date, toFormat format: DateFormat) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.dateFormat
    return dateFormatter.string(from: input)
  }
}

extension DateHelper {
  enum DateFormat {
    case humanFull
    case humanDayMonthYear
    case humanDayMonth
    case humanTime
    case full
    
    var dateFormat: String {
      switch self {
      case .humanFull:
        return "HH:mm dd.MM.yyyy"
      case .humanDayMonthYear:
        return "dd.MM.yyyy"
      case .humanDayMonth:
        return "dd.MM"
      case .humanTime:
        return "HH:mm"
      case .full:
        return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
      }
    }
  }
}
