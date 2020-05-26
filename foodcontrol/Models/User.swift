//
//  User.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseAuth

class User: Object, FirestoreObject {
  
  // MARK: - Properties
  
  @objc dynamic var id: String = ""
  @objc dynamic var username: String = ""
  @objc dynamic var email: String = ""
  @objc dynamic var weightPlanValue: Int = 0
  @objc dynamic var activityValue: Int = 0
  @objc dynamic var sexValue: Int = 0
  @objc dynamic var weight: Double = 0.0
  @objc dynamic var dailyCaloryAmount: Double = 0.0
  
  @objc dynamic var isAnonymous: Bool = false
  @objc dynamic var vkId: String = ""
  
  var friendIds = List<String>()
  
  var weightPlan: WeightPlanType {
    return WeightPlanType(rawValue: weightPlanValue) ?? .unknown
  }
  var activity: ActivityType {
    return ActivityType(rawValue: activityValue) ?? .unknown
  }
  var sex: SexType {
    return SexType(rawValue: sexValue) ?? .unknown
  }
  var isSetup: Bool {
    return weightPlan != .unknown
      && activity != .unknown
      && sex != .unknown
      && dailyCaloryAmount != 0.0
  }
  var isVkConnected: Bool {
    return !vkId.isEmpty
  }
  
  // MARK: - Initializers
  
  convenience init(id: String,
                   username: String,
                   email: String,
                   weightPlan: WeightPlanType? = nil,
                   activity: ActivityType? = nil,
                   sex: SexType? = nil,
                   weight: Double? = nil,
                   dailyCaloryAmount: Double? = nil,
                   isAnonymous: Bool = false,
                   vkId: String? = nil,
                   friendIds: [String] = []) {
    self.init()
    self.id = id
    self.username = username
    self.email = email
    self.weightPlanValue = weightPlan?.rawValue ?? 0
    self.activityValue = activity?.rawValue ?? 0
    self.sexValue = sex?.rawValue ?? 0
    self.weight = weight ?? 0.0
    self.dailyCaloryAmount = dailyCaloryAmount ?? 0.0
    self.isAnonymous = isAnonymous
    self.vkId = vkId ?? ""
    
    self.friendIds.append(objectsIn: friendIds)
  }
  
  convenience init(firebaseUser: FirebaseAuth.User, username: String? = nil) {
    let vkId: String? = {
      guard let vkEmail = firebaseUser.email, vkEmail.hasSuffix("@vkauth.ru") else { return nil }
      guard let userIdSubstring = vkEmail.split(separator: "@").first else { return nil }
      return String(userIdSubstring)
    }()
    self.init(id: firebaseUser.uid,
              username: username ?? "",
              email: firebaseUser.email ?? "",
              isAnonymous: firebaseUser.isAnonymous,
              vkId: vkId)
  }
  
  convenience init?(dictionary: [String: Any]) {
    guard let id = dictionary["uid"] as? String,
      let username = dictionary["username"] as? String,
      let email = dictionary["email"] as? String,
      let weightPlanValue = dictionary["weight_plan_value"] as? Int,
      let activityValue = dictionary["activity_value"] as? Int,
      let sexValue = dictionary["sex_value"] as? Int,
      let dailyCaloryAmount = dictionary["daily_calory_amount"] as? Double,
      let friendIds = dictionary["friend_ids"] as? [String] else { return nil }
    
    self.init(id: id,
              username: username,
              email: email,
              weightPlan: WeightPlanType(rawValue: weightPlanValue),
              activity: ActivityType(rawValue: activityValue),
              sex: SexType(rawValue: sexValue),
              weight: (dictionary["weight"] as? Double) ?? Double(dictionary["weight"] as? Int ?? 0),
              dailyCaloryAmount: dailyCaloryAmount,
              vkId: dictionary["vk_id"] as? String,
              friendIds: friendIds)
  }
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  // MARK: - FirestoreObject protocol
  
  func toDictionary() -> [String : Any] {
    var dictionary: [String: Any] = [
      "uid": id,
      "username": username,
      "email": email,
      "weight_plan_value": weightPlanValue,
      "activity_value": activityValue,
      "sex_value": sexValue,
      "daily_calory_amount": dailyCaloryAmount,
      "friend_ids": Array(friendIds)
    ]
    if weight != 0.0 {
      dictionary["weight"] = weight
    }
    if !vkId.isEmpty {
      dictionary["vk_id"] = vkId
    }
    return dictionary
  }
  
  func getId() -> String {
    return id
  }
  
  func getPath() -> FirebaseManager.FirestorePath {
    return FirebaseManager.FirestorePath.userData
  }
  
  // MARK: - Methods
  
  func update(with dictionary: [String: Any]) {
    guard let id = dictionary["uid"] as? String, id == self.id else { return }
    if let username = dictionary["username"] as? String {
      self.username = username
    }
    if let weightPlanValue = dictionary["weight_plan_value"] as? Int {
      self.weightPlanValue = weightPlanValue
    }
    if let activityValue = dictionary["activity_value"] as? Int {
      self.activityValue = activityValue
    }
    if let sexValue = dictionary["sex_value"] as? Int {
      self.sexValue = sexValue
    }
    if let dailyCaloryAmount = dictionary["daily_calory_amount"] as? Double {
      self.dailyCaloryAmount = dailyCaloryAmount
    }
    if let vkId = dictionary["vk_id"] as? String {
      self.vkId = vkId
    }
    if let friendIds = dictionary["friend_ids"] as? [String] {
      self.friendIds.append(objectsIn: friendIds)
    }
    self.weight = (dictionary["weight"] as? Double) ?? Double(dictionary["weight"] as? Int ?? 0)
  }
  
  func calculateWeekQuality(weekId: String, meals: [Meal]) -> String {
    let filteredMeals = meals.filter({ $0.date.weekId == weekId })
    var dayCalories: [String: Double] = [:]
    for meal in filteredMeals {
      if dayCalories.contains(where: { $0.key == meal.date.dayId }) {
        dayCalories[meal.date.dayId]! += meal.totalCalories
      } else {
        dayCalories[meal.date.dayId] = meal.totalCalories
      }
    }
    
    var successCount: Int = 7
    for day in dayCalories where day.value > dailyCaloryAmount {
      successCount -= 1
    }
    
    return "\(successCount)/7"
  }
  
  func calculateDailyCalorieAmount(weightPlan: User.WeightPlanType? = nil, activity: User.ActivityType? = nil, sex: User.SexType? = nil, weight: Double? = nil) -> Double {
    
    let weightPlan = weightPlan ?? self.weightPlan
    let activity = activity ?? self.activity
    let sex = sex ?? self.sex
    let weight = weight ?? self.weight
    
    var minValue: Double = 0.0
    
    let height: Double = 175.0
    let age: Double = 30.0
    var value: Double = {
      switch sex {
      case .male:
        minValue = 1600.0
        return 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age)
      case .female:
        minValue = 1200.0
        return 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age)
      default:
        return 0.0
      }
    }()
    
    switch activity {
    case .lowActivity:
      value = value * 1.2
    case .mediumActivity:
      value = value * 1.5
    case .highActivity:
      value = value * 1.9
    default:
      break
    }
    
    switch weightPlan {
    case .loseWeight:
      let newValue = value * 0.9
      value = max(minValue, newValue)
    case .keepWeight:
      value = max(minValue, value)
    case .gainWeight:
      let newValue = value * 1.2
      value = max(minValue, newValue)
    default:
      break
    }
    
    return value
  }
}

extension User {
  enum WeightPlanType: Int {
    case unknown
    case loseWeight = 1
    case keepWeight = 2
    case gainWeight = 3
    
    var title: String {
      switch self {
      case .loseWeight:
        return NSLocalizedString("Сбросить", comment: "")
      case .keepWeight:
        return NSLocalizedString("Поддерживать", comment: "")
      case .gainWeight:
        return NSLocalizedString("Набрать", comment: "")
      default:
        return NSLocalizedString("Неизвестно", comment: "") + ": \(self.rawValue)"
      }
    }
    
    var fullTitle: String {
      return title + " " + NSLocalizedString("Вес", comment: "").lowercased()
    }
  }
  
  enum ActivityType: Int {
    case unknown
    case lowActivity = 1
    case mediumActivity = 2
    case highActivity = 3
    
    var title: String {
      switch self {
      case .lowActivity:
        return NSLocalizedString("Низкая", comment: "")
      case .mediumActivity:
        return NSLocalizedString("Средняя", comment: "")
      case .highActivity:
        return NSLocalizedString("Высокая", comment: "")
      default:
        return NSLocalizedString("Неизвестно", comment: "") + ": \(self.rawValue)"
      }
    }
  }
  
  enum SexType: Int {
    case unknown
    case male = 1
    case female = 2
    
    var title: String {
      switch self {
      case .male:
        return NSLocalizedString("Мужчина", comment: "")
      case .female:
        return NSLocalizedString("Женщина", comment: "")
      default:
        return NSLocalizedString("Неизвестно", comment: "") + ": \(self.rawValue)"
      }
    }
  }
}
