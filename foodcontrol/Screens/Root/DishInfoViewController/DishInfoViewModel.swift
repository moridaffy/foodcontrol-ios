//
//  DishInfoViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

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
      var cellModels: [FCTableViewCellModel] = [
        BigImageTableViewCellModel(url: dish.imageUrl),
        InfoTextTableViewCellModel(type: .title, text: dish.name)
      ]
      if !dish.description.isEmpty {
        cellModels.append(InfoTextTableViewCellModel(type: .description, text: dish.description))
      }
      cellModels.append(contentsOf: [
        InfoTextTableViewCellModel(type: .size, text: "\(dish.weight ?? 100)"),
        InfoNutritionTableViewCellModel(dish: dish)
      ] as [FCTableViewCellModel])
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
}
