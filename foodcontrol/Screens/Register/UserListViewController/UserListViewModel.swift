//
//  UserListViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class UserListViewModel {
  
  private let rootUser: User
  private(set) var users: [User] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: UserListViewController?
  
  init(rootUser: User) {
    self.rootUser = rootUser
    
    reloadUsers { (_) in }
  }
  
  func reloadUsers(completionHandler: @escaping (Error?) -> Void) {
    guard !rootUser.friendIds.isEmpty else {
      users = []
      completionHandler(nil)
      return
    }
    var lastError: Error?
    var users: [User] = []
    var pendingUsers: Int = rootUser.friendIds.count {
      didSet {
        if pendingUsers == 0 {
          self.users = users
          completionHandler(lastError)
          return
        }
      }
    }
    
    for friendId in rootUser.friendIds {
      FirebaseManager.shared.loadObject(id: friendId, path: .userData) { (userDictionary, error) in
        if let error = error {
          lastError = error
        }
        if let user = User(dictionary: userDictionary ?? [:]) {
          users.append(user)
        }
        pendingUsers -= 1
      }
    }
  }
  
  func findUser(withId userId: String, completionHandler: @escaping (User?, Error?) -> Void) {
    FirebaseManager.shared.loadObject(id: userId, path: .userData) { (userDictionary, error) in
      completionHandler(User(dictionary: userDictionary ?? [:]), error)
    }
  }
}
