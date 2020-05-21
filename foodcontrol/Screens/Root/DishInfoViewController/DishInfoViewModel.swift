//
//  DishInfoViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class DishInfoViewModel {
  
  let dish: Dish
  let creatingNewDish: Bool
  private(set) var cellModels: [FCTableViewCellModel] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: DishInfoViewController?
  
  init(dish: Dish?) {
    self.dish = dish ?? Dish()
    self.creatingNewDish = dish == nil
    
    reloadCellModels()
  }
  
  func reloadCellModels() {
    if creatingNewDish {
      var cellModels: [FCTableViewCellModel] = []
      if let dishImage = dish.image {
        cellModels.append(BigImageTableViewCellModel(image: dishImage))
      } else {
        cellModels.append(BigButtonTableViewCellModel(type: .addImage))
      }
      cellModels.append(contentsOf: [
        InfoTextTableViewCellModel(type: .title, text: dish.name, editable: true),
        InfoTextTableViewCellModel(type: .description, text: dish.description, editable: true),
        InfoNutritionTableViewCellModel(dish: dish, editable: true)
      ] as [FCTableViewCellModel])
      self.cellModels = cellModels
    } else {
      var cellModels: [FCTableViewCellModel] = []
      if let imageUrl = dish.imageUrl {
        cellModels.append(BigImageTableViewCellModel(url: imageUrl))
      } else {
        cellModels.append(BigImageTableViewCellModel(image: UIImage(named: "dish_placeholder")))
      }
      cellModels.append(InfoTextTableViewCellModel(type: .title, text: dish.name))
      if !dish.description.isEmpty {
        cellModels.append(InfoTextTableViewCellModel(type: .description, text: dish.description))
      }
      if let weight = dish.weight {
        cellModels.append(InfoTextTableViewCellModel(type: .size, text: "\(weight.roundedString(to: 0))"))
      }
      cellModels.append(InfoNutritionTableViewCellModel(dish: dish))
      self.cellModels = cellModels
    }
  }
  
  func createDish(completionHandler: @escaping (Dish?, Error?) -> Void) {
    guard let imageData = dish.image?.jpegData(compressionQuality: 1.0) else {
      completionHandler(nil, nil)
      return
    }
    
    FirebaseManager.shared.uploadFile(imageData, path: .dishImage(nil)) { [weak self] (imageUrl, error) in
      guard let dish = self?.dish else { return }
      if let imageUrl = imageUrl {
        dish.imageUrl = imageUrl
        
        FirebaseManager.shared.uploadObject(dish) { (error) in
          if let error = error {
            completionHandler(nil, error)
          } else {
            completionHandler(dish, nil)
          }
        }
      } else {
        completionHandler(nil, error)
      }
    }
  }
  
  func reportDish(comment: String?, completionHandler: @escaping (Error?) -> Void) {
    let report = Report(dishId: dish.id, comment: comment)
    FirebaseManager.shared.uploadObject(report, completionHandler: completionHandler)
  }
}
