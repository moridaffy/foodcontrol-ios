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
  var totalCallories: Double {
    var totalCallories: Double = 0
    dishes.forEach({ totalCallories += $0.getValue(for: .callories, reference: false) })
    return totalCallories
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
    self.dishes = dishes
  }
  
  convenience init?(dictionary: [String: Any]) {
    guard let id = dictionary["uid"] as? String,
      let dateValue = dictionary["dateValue"] as? String,
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
      "dateValue": dateValue,
      "dish_ids": dishes.compactMap({ $0.id })
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
