//
//  EatingQualityViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 22.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

struct EatingQualityDayCellModel {
  let date: String
  let value: String
  let goodCalories: Bool
}

class EatingQualityViewModel {
  
  private(set) var currentWeekId: String? {
    didSet {
      reloadDisplayedDays()
    }
  }
  private(set) var displayedDays: [EatingQualityDayCellModel] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  /// новее...старее
  var sortedMeals: [Meal] {
    return meals.sorted(by: { $0.date > $1.date })
  }
  
  let meals: [Meal]
  let dailyCalories: Double
  
  weak var view: EatingQualityViewController?
  
  init(meals: [Meal], dailyCalories: Double) {
    self.meals = meals
    self.dailyCalories = dailyCalories
    
    currentWeekId = sortedMeals.first?.date.weekId
    reloadDisplayedDays()
  }
  
  private func reloadDisplayedDays() {
    guard !meals.isEmpty else { return }
    let currentWeekId = self.currentWeekId ?? sortedMeals.first!.date.weekId
    let filteredMeals = sortedMeals.filter({ $0.date.weekId == currentWeekId })
    guard let referenceDate = filteredMeals.first?.date else { return }
    var displayedDays: [EatingQualityDayCellModel] = []
    let calendar = Calendar.current
    for i in 2...8 {
      var totalCalories: Double = 0.0
      let dayMeals = filteredMeals.filter({ calendar.component(.weekday, from: $0.date) == i })
      let date: Date = dayMeals.first?.date ?? referenceDate.addingTimeInterval(Double(i - calendar.component(.weekday, from: referenceDate)) * 86400.0)
      for dayMeal in dayMeals {
        totalCalories += dayMeal.totalCalories
      }
      displayedDays.append(EatingQualityDayCellModel(date: DateHelper().getString(from: date, toFormat: .humanDayMonthYear),
                                                     value: "\(totalCalories.roundedString(to: 1, separator: ","))ккал из \(dailyCalories.roundedString(to: 1, separator: ","))ккал",
                                                     goodCalories: totalCalories <= dailyCalories))
    }
    self.displayedDays = displayedDays
  }
  
  func getPreviousWeekId() -> String? {
    guard let currentWeek = Int(currentWeekId?.split(separator: ".").first ?? "") else { return nil }
    let previousWeekId = "\(currentWeek - 1).2020"
    if meals.filter({ $0.date.weekId == previousWeekId }).isEmpty {
      return nil
    } else {
      return previousWeekId
    }
  }
  
  func getNextWeekId() -> String? {
    guard let currentWeek = Int(currentWeekId?.split(separator: ".").first ?? "") else { return nil }
    let previousWeekId = "\(currentWeek + 1).2020"
    if meals.filter({ $0.date.weekId == previousWeekId }).isEmpty {
      return nil
    } else {
      return previousWeekId
    }
  }
  
  func switchToPreviousWeek() {
    guard let previousWeekId = getPreviousWeekId() else { return }
    currentWeekId = previousWeekId
  }
  
  func switchToNextWeek() {
    guard let nextWeekId = getNextWeekId() else { return }
    currentWeekId = nextWeekId
  }
  
}
