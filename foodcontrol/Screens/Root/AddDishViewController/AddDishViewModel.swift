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
      reloadCellModels()
    }
  }
  var searchQuery: String = "" {
    didSet {
      reloadCellModels()
    }
  }
  
  private var displayedDishes: [Dish] = TestInstances.dishes
  private(set) var cellModels: [FCTableViewCellModel] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  private func reloadCellModels() {
    var sortedDishes: [Dish] = {
      switch sortingType {
      case .calloriesAsc:
        return displayedDishes.sorted(by: { $0.calloriesReference < $1.calloriesReference })
      case .calloriesDesc:
        return displayedDishes.sorted(by: { $0.calloriesReference > $1.calloriesReference })
      case .nameAsc:
        return displayedDishes.sorted(by: { $0.name > $1.name })
      case .nameDesc:
        return displayedDishes.sorted(by: { $0.name < $1.name })
      }
    }()
    
    if !searchQuery.isEmpty {
      sortedDishes = sortedDishes.filter({ $0.name.contains(searchQuery) })
    }
    
    cellModels = [BigButtonTableViewCellModel(type: .createDish)] + sortedDishes.compactMap({ DishTableViewCellModel(dish: $0) })
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
