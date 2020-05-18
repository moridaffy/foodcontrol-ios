//
//  CreateMealViewControllerModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation
import CoreLocation

class CreateMealViewControllerModel {
  
  let meal: Meal = Meal(dishes: [])
  private(set) var cellModels: [FCTableViewCellModel] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: CreateMealViewController?
  
  init() {
    cellModels = [
      MealHeaderTableViewCellModel(meal: meal),
      BigButtonTableViewCellModel(type: .addDish),
      MapLocationTableViewCellModel(coordinate: CLLocationCoordinate2D(latitude: 55.766041, longitude: 37.684551))
    ]
  }
  
  private func reloadCellModels() {
    var cellModels: [FCTableViewCellModel] = []
    cellModels.append(MealHeaderTableViewCellModel(meal: meal))
    for dish in meal.dishes {
      cellModels.append(DishTableViewCellModel(dish: dish))
    }
    cellModels.append(BigButtonTableViewCellModel(type: .addDish))
    cellModels.append(MapLocationTableViewCellModel(coordinate: CLLocationCoordinate2D(latitude: 55.766041, longitude: 37.684551)))
    self.cellModels = cellModels
  }
  
  func didAddDish(_ dish: Dish) {
    guard meal.dishes.first(where: { $0.id == dish.id }) == nil else { return }
    meal.dishes.append(dish)
    reloadCellModels()
  }
  
  func createMeal(completionHandler: @escaping (Error?) -> Void) {
    fixAllDishesIfNeeded { (error) in
      guard error == nil else {
        completionHandler(error)
        return
      }
      
      FirebaseManager.shared.uploadObject(self.meal, completionHandler: completionHandler)
    }
  }
  
  private func fixAllDishesIfNeeded(completionHandler: @escaping (Error?) -> Void) {
    var lastError: Error?
    var pendingDishesCount: Int = meal.dishes.count {
      didSet {
        if pendingDishesCount == 0 {
          completionHandler(lastError)
        }
      }
    }
    
    for dish in meal.dishes {
      FirebaseManager.shared.loadObject(id: dish.id, path: .dish) { (dishDictionary, error) in
        if let error = error {
          lastError = error
        }
        
        if dishDictionary == nil {
          FirebaseManager.shared.uploadObject(dish) { (error) in
            if let error = error {
              lastError = error
            }
            pendingDishesCount -= 1
          }
        } else {
          pendingDishesCount -= 1
        }
      }
    }
  }
}
