//
//  Meal.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import CoreLocation

class Meal: FirestoreObject {
  let id: String
  let dateValue: String
  var coordinates: CLLocationCoordinate2D?
  var dishes: [Dish]
  var userId: String
  
  var date: Date {
    return DateHelper().getDate(from: dateValue, ofFormat: .full) ?? Date()
  }
  var totalCalories: Double {
    var totalCalories: Double = 0
    dishes.forEach({ totalCalories += $0.getValue(for: .calories, reference: false) })
    return totalCalories
  }
  
  // MARK: - Initializers
  
  init(id: String = UUID().uuidString,
       userId: String? = nil,
       dateValue: String = DateHelper().getString(from: Date(), toFormat: .full),
       coordinates: CLLocationCoordinate2D? = nil,
       dishes: [Dish] = []) {
    self.id = id
    self.userId = userId ?? AuthManager.shared.currentUser?.id ?? "NO_USER_ID"
    self.dateValue = dateValue
    self.coordinates = coordinates
    self.dishes = dishes.sorted(by: { $0.id > $1.id })
  }
  
  convenience init?(dictionary: [String: Any]) {
    guard let id = dictionary["uid"] as? String,
      let dateValue = dictionary["date_value"] as? String,
      let userId = dictionary["user_id"] as? String else { return nil }
    
    let coordinates: CLLocationCoordinate2D? = {
      if let latitude = dictionary["coordinates_lat"] as? Double,
        let longitude = dictionary["coordinates_lon"] as? Double {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      } else {
        return nil
      }
    }()
    
    self.init(id: id,
              userId: userId,
              dateValue: dateValue,
              coordinates: coordinates)
  }
  
  // MARK: - FirestoreObject protocol
  
  func toDictionary() -> [String : Any] {
    var dictionary: [String: Any] = [
      "uid": id,
      "date_value": dateValue,
      "dishes_json": MealDishArrayCodable.getJsonString(dishes: dishes)
    ]
    if let coordinates = coordinates {
      dictionary["coordinates_lat"] = coordinates.latitude
      dictionary["coordinates_lon"] = coordinates.longitude
    }
    if let userId = AuthManager.shared.currentUser?.id {
      dictionary["user_id"] = userId
    }
    return dictionary
  }
  
  func getId() -> String {
    return id
  }
  
  func getPath() -> FirebaseManager.FirestorePath {
    return FirebaseManager.FirestorePath.meal
  }
}

struct MealDishArrayCodable: Codable {
  let dishes: [MealDishCodable]
  
  static func getJsonString(dishes: [Dish]) -> String {
    let dishesCodable = dishes.compactMap({ MealDishCodable(dish: $0) })
    let codable = MealDishArrayCodable(dishes: dishesCodable)
    guard let jsonData = try? JSONEncoder().encode(codable) else { fatalError("can't serialize json") }
    guard let jsonString = String(data: jsonData, encoding: .utf8) else { fatalError("can't get json string from jsonData") }
    return jsonString
  }
  
  init(dishes: [MealDishCodable]) {
    self.dishes = dishes
  }
  
  init?(jsonString: String) {
    guard let jsonData = jsonString.data(using: .utf8),
      let codable = try? JSONDecoder().decode(MealDishArrayCodable.self, from: jsonData) else { return nil }
    self.dishes = codable.dishes
  }
}

struct MealDishCodable: Codable {
  let dishId: String
  let weight: Double
  
  init(dish: Dish) {
    self.dishId = dish.id
    self.weight = dish.weight ?? 0.0
  }
}
