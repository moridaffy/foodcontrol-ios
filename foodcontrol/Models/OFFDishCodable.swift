//
//  OFFDishCodable.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 17.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class OFFDishListResponse: Decodable {
  let products: [OFFDishCodable]
}

class OFFDishCodable: Decodable {
  let id: String
  let name: String?
  let imageUrl: String?
  let nutritions: OFFDishNutritionCodable
  
  enum CodingKeys: String, CodingKey {
    case id
    case nameRu = "generic_name_ru"
    case name = "generic_name"
    case imageUrl = "image_front_url"
    case nutritions = "nutriments"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let nameRu = try container.decodeIfPresent(String.self, forKey: .nameRu)
    let name = try container.decodeIfPresent(String.self, forKey: .name)
    self.name = nameRu ?? name
    
    self.id = try container.decode(String.self, forKey: .id)
    self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    self.nutritions = try container.decode(OFFDishNutritionCodable.self, forKey: .nutritions)
  }
}

class OFFDishNutritionCodable: Decodable {
  let proteinsReference: Double?
  let fatsReference: Double?
  let carbohydratesReference: Double?
  let caloriesReference: Double?
  
  enum CodingKeys: String, CodingKey {
    case proteins = "proteins"
    case proteinsValue = "proteins_value"
    case proteins100g = "proteins_100g"
    
    case fat = "fat"
    case fatValue = "fat_value"
    case fats100g = "fat_100g"
    
    case carbohydrates = "carbohydrates"
    case carbohydratesValue = "carbohydrates_value"
    case carbohydrates100g = "carbohydrates_100g"
    
    case energy = "energy"
    case energyKcal = "energy-kcal"
    case enery100g = "energy_100g"
    case energyKcal100g = "energy-kcal_100g"
  }
  
  required init(from decoder: Decoder) throws {
    
    func getValue(_ container: KeyedDecodingContainer<OFFDishNutritionCodable.CodingKeys>, for codingKeys: [CodingKeys]) -> Double? {
      for codingKey in codingKeys {
        if let intValue = try? container.decode(Int.self, forKey: codingKey) {
          return Double(intValue)
        } else if let doubleValue = try? container.decode(Double.self, forKey: codingKey) {
          return doubleValue
        }
      }
      return nil
    }
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.proteinsReference = getValue(container, for: [
      .proteins100g,
      .proteins,
      .proteinsValue
    ])
    self.fatsReference = getValue(container, for: [
      .fats100g,
      .fat,
      .fatValue
    ])
    self.carbohydratesReference = getValue(container, for: [
      .carbohydrates100g,
      .carbohydratesValue,
      .carbohydrates
    ])
    self.caloriesReference = getValue(container, for: [
      .energyKcal100g,
      .enery100g,
      .energyKcal,
      .energy
    ])
  }
}
