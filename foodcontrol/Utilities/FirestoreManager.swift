//
//  FirestoreManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 07.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import FirebaseFirestore

protocol FirestoreObject: class {
  func toDictionary() -> [String: Any]
}

class FirestoreManager {
  
  static let shared = FirestoreManager()
  
  private let firestore: Firestore
  
  init() {
    firestore = Firestore.firestore()
  }
  
  func uploadObject(_ object: FirestoreObject, path: String, completionHandler: @escaping (Bool?, Error?) -> Void) {
    
  }
  
}
