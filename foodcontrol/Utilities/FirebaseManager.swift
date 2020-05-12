//
//  FirestoreManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 07.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

protocol FirestoreObject: class {
  func toDictionary() -> [String: Any]
  func getId() -> String
  func getPath() -> FirebaseManager.FirestorePath
}

class FirebaseManager {
  
  static let shared = FirebaseManager()
  
  private let firestore: Firestore
  
  init() {
    firestore = Firestore.firestore()
  }
  
  func register(username: String, email: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let firebaseUser = authResult?.user {
        let user = User(firebaseUser: firebaseUser, username: username)
        completionHandler(user, nil)
      } else {
        completionHandler(nil, error)
      }
    }
  }
  
  func uploadObject(_ object: FirestoreObject, merge: Bool = false, completionHandler: @escaping (Error?) -> Void) {
    firestore.collection(object.getPath().rawValue).document(object.getId()).setData(object.toDictionary(), merge: merge) { error in
      completionHandler(error)
    }
  }
}

extension FirebaseManager {
  enum FirestorePath: String {
    case userData = "user"
  }
}
