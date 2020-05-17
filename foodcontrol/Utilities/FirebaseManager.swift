//
//  FirestoreManager.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 07.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol FirestoreObject: class {
  func toDictionary() -> [String: Any]
  func getId() -> String
  func getPath() -> FirebaseManager.FirestorePath
}

class FirebaseManager {
  
  static let shared = FirebaseManager()
  
  private let firestore: Firestore
  private let storage: Storage
  
  init() {
    firestore = Firestore.firestore()
    storage = Storage.storage()
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
  
  func login(email: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
      if let firebaseUser = authResult?.user {
        let user = User(firebaseUser: firebaseUser)
        self.loadObject(id: user.id, path: .userData) { (userData, error) in
          if let userData = userData {
            user.update(with: userData)
            completionHandler(user, nil)
          } else {
            completionHandler(nil, error)
          }
        }
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
  
  func loadObject(id: String, path: FirestorePath, completionHandler: @escaping ([String: Any]?, Error?) -> Void) {
    firestore.collection(path.rawValue).document(id).getDocument { (document, error) in
      if let dictionary = document?.data() {
        completionHandler(dictionary, nil)
      } else {
        completionHandler(nil, error)
      }
    }
  }
  
  func loadObjects(where field: String, equals filterValue: Any, path: FirestorePath, completionHandler: @escaping ([[String: Any]]?, Error?) -> Void) {
    firestore.collection(path.rawValue).whereField(field, isEqualTo: filterValue).getDocuments { (query, error) in
      if let documentDictionaries = query?.documents.compactMap({ $0.data() }) {
        completionHandler(documentDictionaries, nil)
      } else {
        completionHandler(nil, error)
      }
    }
  }
  
  func loadObjects(path: FirestorePath, completionHandler: @escaping ([[String: Any]]?, Error?) -> Void) {
    firestore.collection(path.rawValue).getDocuments { (query, error) in
      if let documentDictionaries = query?.documents.compactMap({ $0.data() }) {
        completionHandler(documentDictionaries, nil)
      } else {
        completionHandler(nil, error)
      }
    }
  }

  func uploadFile(_ data: Data, path: StoragePath, completionHandler: @escaping (URL?, Error?) -> Void) {
    let rootReference = storage.reference()
    let fileReference = rootReference.child(path.path)
    
    fileReference.putData(data, metadata: nil) { (metadata, error) in
      guard metadata != nil && error == nil else {
        completionHandler(nil, error)
        return
      }
      fileReference.downloadURL(completion: completionHandler)
    }.resume()
  }
}

extension FirebaseManager {
  enum FirestorePath: String {
    case userData = "user"
    case dish = "dish"
  }
  
  enum StoragePath {
    case dishImage(String?)
    
    var path: String {
      switch self {
      case .dishImage(let imageName):
        return "images/dishes/\(imageName ?? UUID().uuidString).jpeg"
      }
    }
  }
}
