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
      searchForDishes()
    }
  }
  
  private var dishes: [Dish] = [] {
    didSet {
      reloadCellModels()
    }
  }
  private(set) var cellModels: [FCTableViewCellModel] = [BigButtonTableViewCellModel(type: .createDish)] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  private func searchForDishes() {
    guard !searchQuery.isEmpty else {
      dishes = []
      return
    }
    
    APIManager.shared.searchForDishes(byName: searchQuery) { [weak self] (offDishes, error) in
      if let offDishes = offDishes {
        self?.dishes = offDishes.compactMap({ Dish(offDish: $0) })
      } else {
        self?.view?.showAlertError(error: error,
                                   desc: NSLocalizedString("Не удалось загрузить список блюд", comment: ""),
                                   critical: false)
      }
    }
  }
  
  private func reloadCellModels() {
    let sortedDishes: [Dish] = {
      switch sortingType {
      case .calloriesAsc:
        return dishes.sorted(by: { ($0.calloriesReference ?? 0.0) < ($1.calloriesReference ?? 0.0) })
      case .calloriesDesc:
        return dishes.sorted(by: { ($0.calloriesReference ?? 0.0) > ($1.calloriesReference ?? 0.0) })
      case .nameAsc:
        return dishes.sorted(by: { $0.name > $1.name })
      case .nameDesc:
        return dishes.sorted(by: { $0.name < $1.name })
      }
    }()
    
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
