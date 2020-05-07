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
  private(set) var cellModels: [FCTableViewCellModel] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: DishInfoViewController?
  
  init(dish: Dish) {
    self.dish = dish
    
    generateCellModels()
  }
  
  private func generateCellModels() {
    cellModels = [
      BigImageTableViewCellModel(url: dish.imageUrl),
      InfoTextTableViewCellModel(type: .title, text: dish.name),
      InfoTextTableViewCellModel(type: .description, text: dish.description),
      InfoTextTableViewCellModel(type: .size, text: "\(dish.weight ?? 100)"),
      InfoNutritionTableViewCellModel(dish: dish)
    ]
  }
  
}
