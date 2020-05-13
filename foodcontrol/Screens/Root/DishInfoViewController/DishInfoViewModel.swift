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
        InfoTextTableViewCellModel(type: .title, editable: true),
        InfoTextTableViewCellModel(type: .description, editable: true),
        InfoTextTableViewCellModel(type: .size, editable: true)
      ]
    } else {
      cellModels = [
        BigImageTableViewCellModel(url: dish.imageUrl),
        InfoTextTableViewCellModel(type: .title, text: dish.name),
        InfoTextTableViewCellModel(type: .description, text: dish.description),
        InfoTextTableViewCellModel(type: .size, text: "\(dish.weight ?? 100)"),
        InfoNutritionTableViewCellModel(dish: dish)
      ]
    }
  }
  
}
