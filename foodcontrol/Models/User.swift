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
  @objc dynamic var weight: Double = 0.0
  
  @objc dynamic var vkId: String = ""
  
  var weightPlan: WeightPlanType {
    return WeightPlanType(rawValue: weightPlanValue) ?? .unknown
  }
  var activity: ActivityType {
    return ActivityType(rawValue: activityValue) ?? .unknown
  }
  var vkLinked: Bool {
    return !vkId.isEmpty
  }
  var isSetup: Bool {
    return weightPlan != .unknown && activity != .unknown
  }
  
  // MARK: - Initializers
  
  convenience init(id: String,
                   username: String,
                   email: String,
                   weightPlan: WeightPlanType? = nil,
                   activity: ActivityType? = nil,
                   weight: Double? = nil,
                   vkId: String? = nil) {
    self.init()
    self.id = id
    self.username = username
    self.email = email
    self.weightPlanValue = weightPlan?.rawValue ?? 0
    self.activityValue = activity?.rawValue ?? 0
    self.weight = weight ?? 0.0
    self.vkId = vkId ?? ""
  }
  
  convenience init(firebaseUser: FirebaseAuth.User, username: String? = nil) {
    self.init(id: firebaseUser.uid,
              username: username ?? "",
              email: firebaseUser.email ?? "")
  }
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  // MARK: - FirestoreObject protocol
  
  func toDictionary() -> [String : Any] {
    var dictionary: [String: Any] = [
      "uid": id,
      "username": username,
      "weightPlanValue": weightPlanValue,
      "activityValue": activityValue
    ]
    if weight != 0.0 {
      dictionary["weight"] = weight
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
    if let weightPlanValue = dictionary["weightPlanValue"] as? Int {
      self.weightPlanValue = weightPlanValue
    }
    if let activityValue = dictionary["activityValue"] as? Int {
      self.activityValue = activityValue
    }
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
}
