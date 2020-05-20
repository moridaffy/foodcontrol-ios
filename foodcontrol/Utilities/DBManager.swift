//
//  DBManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import RealmSwift
import Foundation

class DBManager {
  
  static let shared = DBManager()
  
  private let dbQueue = DispatchQueue(label: Bundle.main.bundleIdentifier ?? "ru.mskr.foodcontrol" + ".RealmQueue")
  
  func saveObject(_ object: Object, update: Bool = true) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          realm.add(object, update: .all)
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (saveObject): \(error.localizedDescription)")
      }
    }
  }
  
  func saveObjects(_ objects: [Object], update: Bool = true) {
    if !objects.isEmpty {
      dbQueue.sync {
        do {
          let realm = try Realm()
          try realm.write {
            realm.add(objects, update: .all)
            try realm.commitWrite()
          }
        } catch let error {
          fatalError("🔥 Error at DBManager (saveObjects): \(error.localizedDescription)")
        }
      }
    }
  }
  
  func getObject<T: Object>(_ type: T.Type, forKey key: String) -> T? {
    do {
      let realm = try Realm()
      return realm.object(ofType: T.self, forPrimaryKey: key)
    } catch let error {
      fatalError("🔥 Error at DBManager (getObject): \(error.localizedDescription)")
    }
  }
  
  func getObjects<T: Object>(type: T.Type, predicate: NSPredicate?) -> Results<T> {
    do {
      let realm = try Realm()
      if let predicate = predicate {
        return realm.objects(T.self).filter(predicate)
      } else {
        return realm.objects(T.self)
      }
    } catch let error {
      fatalError("🔥 Error at DBManager (getObjects): \(error.localizedDescription)")
    }
  }
  
  func deleteObjects(_ objects: [Object]?) {
    if let objects = objects, !objects.isEmpty {
      dbQueue.sync {
        do {
          let realm = try Realm()
          try realm.write {
            realm.delete(objects)
            try realm.commitWrite()
          }
        } catch let error {
          fatalError("🔥 Error at DBManager (deleteObjects): \(error.localizedDescription)")
        }
      }
    }
  }
  
  func deleteAll() {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          realm.deleteAll()
          try realm.commitWrite()
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (deleteAll): \(error.localizedDescription)")
      }
    }
  }
  
  func updateUser(user: User,
                  weightPlanValue: Int? = nil,
                  activityValue: Int? = nil,
                  sexValue: Int? = nil,
                  weight: Double? = nil,
                  dailyCaloryAmount: Double? = nil,
                  friendIds: [String]? = nil,
                  complationHandler: ((Bool) -> Void)? = nil) {
    dbQueue.sync {
      do {
        let realm = try Realm()
        try realm.write {
          if let weightPlanValue = weightPlanValue {
            user.weightPlanValue = weightPlanValue
          }
          if let activityValue = activityValue {
            user.activityValue = activityValue
          }
          if let sexValue = sexValue {
            user.sexValue = sexValue
          }
          if let weight = weight {
            user.weight = weight
          }
          if let dailyCaloryAmount = dailyCaloryAmount {
            user.dailyCaloryAmount = dailyCaloryAmount
          }
          if let friendIds = friendIds {
            user.friendIds.removeAll()
            user.friendIds.append(objectsIn: friendIds)
          }
          try realm.commitWrite()
          complationHandler?(true)
        }
      } catch let error {
        fatalError("🔥 Error at DBManager (updateUser): \(error.localizedDescription)")
      }
    }
  }
}
