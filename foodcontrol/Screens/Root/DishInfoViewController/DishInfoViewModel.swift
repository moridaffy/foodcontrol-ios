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
    
    generateCellModels()
  }
  
  private func generateCellModels() {
    if creatingNewDish {
      cellModels = [
        BigButtonTableViewCellModel(type: .addImage),
        InfoTextTableViewCellModel(type: .title, text: dish.name, editable: true),
        InfoTextTableViewCellModel(type: .description, text: dish.description, editable: true),
        InfoTextTableViewCellModel(type: .size, editable: true)
      ]
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
}
