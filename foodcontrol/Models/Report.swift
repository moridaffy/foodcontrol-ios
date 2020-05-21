//
//  Report.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 21.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class Report: FirestoreObject {
  let id: String
  let dishId: String
  let comment: String?
  
  // MARK: - Initializers
  
  init(id: String = UUID().uuidString,
       dishId: String,
       comment: String?) {
    self.id = id
    self.dishId = dishId
    self.comment = comment
  }
  
  // MARK: - FirestoreObject protocol
  
  func toDictionary() -> [String : Any] {
    var dictionary: [String: Any] = [
      "uid": id,
      "dish_id": dishId,
      "author_id": AuthManager.shared.currentUser?.id ?? "anonymous"
    ]
    if let comment = comment {
      dictionary["comment"] = comment
    }
    return dictionary
  }
  
  func getId() -> String {
    return id
  }
  
  func getPath() -> FirebaseManager.FirestorePath {
    return FirebaseManager.FirestorePath.report
  }
}
