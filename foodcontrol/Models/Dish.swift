//
//  Dish.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class Dish: FirestoreObject {
  
  // MARK: - Properties
  
  let id: String
  var name: String
  var description: String
  
  var proteinsReference: Double?
  var fatsReference: Double?
  var carbohydratesReference: Double?
  var calloriesReference: Double?
  
  var weight: Double?
  
  /// Имеет значение только при создании блюда. Во всех других случаях стоит обращаться к imageUrl
  var image: UIImage?
  var imageUrl: URL?
  
  var isNutritionInfoFilled: Bool {
    return proteinsReference != nil
      && fatsReference != nil
      && carbohydratesReference != nil
      && calloriesReference != nil
  }
  
  // MARK: - Initializers
  
  init(id: String = UUID().uuidString,
       name: String = "",
       imageUrl: URL? = nil,
       description: String? = nil,
       proteinsReference: Double? = nil,
       fatsReference: Double? = nil,
       carbohydratesReference: Double? = nil,
       calloriesReference: Double? = nil) {
    self.id = id
    self.name = name
    self.imageUrl = imageUrl
    self.description = description ?? ""
    self.proteinsReference = proteinsReference
    self.fatsReference = fatsReference
    self.carbohydratesReference = carbohydratesReference
    self.calloriesReference = calloriesReference
  }
  
  // MARK: - FirestoreObject protocol
  
  func toDictionary() -> [String : Any] {
    var dictionary: [String: Any] = [
      "uid": id,
      "name": name,
      "description": description,
      "proteins_reference": proteinsReference ?? 0.0,
      "fats_reference": fatsReference ?? 0.0,
      "carbohydrates_reference": carbohydratesReference ?? 0.0,
      "callories_reference": calloriesReference ?? 0.0,
      "image_url": imageUrl?.absoluteString ?? ""
    ]
    if let weight = weight {
      dictionary["weight"] = weight
    }
    return dictionary
  }
  
  func getId() -> String {
    return id
  }
  
  func getPath() -> FirebaseManager.FirestorePath {
    return FirebaseManager.FirestorePath.dish
  }
  
  func getValue(for type: ValueType, reference: Bool) -> Double {
    let weight = reference ? 100.0 : (self.weight ?? 0.0)
    switch type {
    case .proteins:
      return proteinsReference ?? 0.0 * weight
    case .fats:
      return fatsReference ?? 0.0 * weight
    case .carbohydrates:
      return carbohydratesReference ?? 0.0 * weight
    case .callories:
      return calloriesReference ?? 0.0 * weight
    }
  }
}

extension Dish {
  enum ValueType {
    
    static let allUnits: [ValueType] = [.proteins, .fats, .carbohydrates, .callories]
    
    case proteins
    case fats
    case carbohydrates
    case callories
    
    var title: String {
      switch self {
      case .proteins:
        return NSLocalizedString("Белки", comment: "")
      case .fats:
        return NSLocalizedString("Жиры", comment: "")
      case .carbohydrates:
        return NSLocalizedString("Углеводы", comment: "")
      case .callories:
        return NSLocalizedString("Каллории", comment: "")
      }
    }
    
    var unit: String {
      switch self {
      case .proteins, .fats, .carbohydrates:
        return NSLocalizedString("г", comment: "")
      case .callories:
        return NSLocalizedString("ккал", comment: "")
      }
    }
  }
}
