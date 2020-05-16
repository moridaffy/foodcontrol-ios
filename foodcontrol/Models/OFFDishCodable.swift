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
  let name: String
  let imageUrl: String
  
  let proteinsReference: String
  let fatsReference: String
  let carbohydraresReference: String
  let caloriesReference: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name = "generic_name_ru"
    case imageUrl = "image_front_url"
    
    case proteinsReference = "proteins_100g"
    case fatsReference = "fat_100g"
    case carbohydraresReference = "carbohydrates_100g"
    case caloriesReference = "energy_100g"
  }
}
