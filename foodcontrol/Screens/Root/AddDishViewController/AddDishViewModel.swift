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
  
  var sortingType: SortingType = .caloriesAsc {
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
    
    getOffDishes { [weak self] (offDishes, error) in
      guard let offDishes = offDishes else {
        self?.view?.showAlertError(error: error,
                                   desc: NSLocalizedString("Не удалось загрузить список блюд", comment: "") + ": OFF",
                                   critical: false)
        return
      }
      
      self?.getFbDishes(completionHandler: { (fbDishes, error) in
        guard let fbDishes = fbDishes else {
          self?.view?.showAlertError(error: error,
                                     desc: NSLocalizedString("Не удалось загрузить список блюд", comment: "") + ": FB",
                                     critical: false)
          return
        }
        
        self?.combineDishes(fbDishes: fbDishes, offDishes: offDishes)
      })
    }
  }
  
  private func getOffDishes(completionHandler: @escaping ([Dish]?, Error?) -> Void) {
    APIManager.shared.searchForDishes(byName: searchQuery) { (offDishes, error) in
      if let offDishes = offDishes {
        let dishes = offDishes.compactMap({ Dish(offDish: $0) })
        completionHandler(dishes, nil)
      } else {
        completionHandler(nil, error)
      }
    }
  }
  
  private func getFbDishes(completionHandler: @escaping ([Dish]?, Error?) -> Void) {
    FirebaseManager.shared.loadObjects(path: .dish) { (dishDictionaries, error) in
      if let dishDictionaries = dishDictionaries {
        let dishes = dishDictionaries
          .compactMap({ Dish(dictionary: $0) })
          .filter({ $0.name.lowercased().contains(self.searchQuery.lowercased()) })
        completionHandler(dishes, nil)
      } else {
        completionHandler(nil, error)
      }
    }
  }
  
  private func combineDishes(fbDishes: [Dish], offDishes: [Dish]) {
    var dishes: [Dish] = []
    for offDish in offDishes {
      if !fbDishes.contains(where: { $0.offId == offDish.id }) {
        dishes.append(offDish)
      }
    }
    dishes.append(contentsOf: fbDishes)
    self.dishes = dishes
  }
  
  private func reloadCellModels() {
    let sortedDishes: [Dish] = {
      switch sortingType {
      case .caloriesAsc:
        return dishes.sorted(by: { ($0.calories ?? 0.0) < ($1.calories ?? 0.0) })
      case .caloriesDesc:
        return dishes.sorted(by: { ($0.calories ?? 0.0) > ($1.calories ?? 0.0) })
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
    case caloriesAsc
    case caloriesDesc
    case nameAsc
    case nameDesc
    
    var title: String {
      switch self {
      case .caloriesAsc:
        return NSLocalizedString("По калорийности (возр.)", comment: "")
      case .caloriesDesc:
        return NSLocalizedString("По калорийности (убыв.)", comment: "")
      case .nameAsc:
        return NSLocalizedString("По названию (возр.)", comment: "")
      case .nameDesc:
        return NSLocalizedString("По названию (убыв.)", comment: "")
      }
    }
  }
}
