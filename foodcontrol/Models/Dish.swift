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
  let offId: String?
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
       offId: String? = nil,
       name: String = "",
       imageUrl: URL? = nil,
       description: String? = nil,
       proteinsReference: Double? = nil,
       fatsReference: Double? = nil,
       carbohydratesReference: Double? = nil,
       calloriesReference: Double? = nil) {
    self.id = id
    self.offId = offId
    self.name = name
    self.imageUrl = imageUrl
    self.description = description ?? ""
    self.proteinsReference = proteinsReference
    self.fatsReference = fatsReference
    self.carbohydratesReference = carbohydratesReference
    self.calloriesReference = calloriesReference
  }
  
  convenience init?(offDish: OFFDishCodable) {
    guard let name = offDish.name, !name.isEmpty, offDish.nutritions.caloriesReference != nil else { return nil }
        
    self.init(offId: offDish.id,
              name: name,
              imageUrl: URL(string: offDish.imageUrl ?? ""),
              proteinsReference: offDish.nutritions.proteinsReference,
              fatsReference: offDish.nutritions.fatsReference,
              carbohydratesReference: offDish.nutritions.carbohydratesReference,
              calloriesReference: offDish.nutritions.caloriesReference)
  }
  
  convenience init?(dictionary: [String: Any]) {
    guard let id = dictionary["uid"] as? String,
      let name = dictionary["name"] as? String,
      let proteinsReference = dictionary["proteins_reference"] as? Double,
      let fatsReference = dictionary["fats_reference"] as? Double,
      let carbohydratesReference = dictionary["carbohydrates_reference"] as? Double,
      let calloriesReference = dictionary["callories_reference"] as? Double else { return nil }
    
    self.init(id: id,
              offId: dictionary["off_id"] as? String,
              name: name,
              imageUrl: URL(string: dictionary["image_url"] as? String ?? ""),
              description: dictionary["description"] as? String,
              proteinsReference: proteinsReference,
              fatsReference: fatsReference,
              carbohydratesReference: carbohydratesReference,
              calloriesReference: calloriesReference)
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
    if let offId = self.offId, !offId.isEmpty {
      dictionary["off_id"] = offId
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
