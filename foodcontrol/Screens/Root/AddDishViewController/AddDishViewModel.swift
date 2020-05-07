//
//  AddDishViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class AddDishViewModel {
  
  weak var view: AddDishViewController?
  
  var sortingType: SortingType = .calloriesAsc {
    didSet {
      sortingTypeChanged()
    }
  }
  
  let cellModels: [FCTableViewCellModel] = [
    BigButtonTableViewCellModel(type: .createDish),
    DishTableViewCellModel(dish: TestInstances.dishes[0]),
    DishTableViewCellModel(dish: TestInstances.dishes[1]),
    DishTableViewCellModel(dish: TestInstances.dishes[2])
  ]
  
  private func sortingTypeChanged() {
    // TODO: сортировка блюд
    view?.sortingTypeChanged()
  }
}

extension AddDishViewModel {
  enum SortingType {
    case calloriesAsc
    case calloriesDesc
    case nameAsc
    case nameDesc
    
    var title: String {
      switch self {
      case .calloriesAsc:
        return NSLocalizedString("По каллорийности (возр.)", comment: "")
      case .calloriesDesc:
        return NSLocalizedString("По каллорийности (убыв.)", comment: "")
      case .nameAsc:
        return NSLocalizedString("По названию (возр.)", comment: "")
      case .nameDesc:
        return NSLocalizedString("По названию (убыв.)", comment: "")
      }
    }
  }
}
