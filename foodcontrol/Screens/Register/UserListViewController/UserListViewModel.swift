//
//  UserListViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class UserListViewModel {
  
  let rootUser: User
  var isMyList: Bool {
    return rootUser.id == AuthManager.shared.currentUser?.id
  }
  private(set) var users: [User] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: UserListViewController?
  
  init(rootUser: User, users: [User]? = nil) {
    self.rootUser = rootUser
    
    reloadUsers(users: users, completionHandler: { _ in })
  }
  
  func reloadUsers(users: [User]? = nil, completionHandler: @escaping (Error?) -> Void) {
    guard users == nil else {
      self.users = users!
      completionHandler(nil)
      return
    }
    guard !rootUser.friendIds.isEmpty else {
      self.users = []
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
  
  func findVkFriends(completionHandler: @escaping ([String]?, Error?) -> Void) {
    VKManager.shared.getFriendIds(completionHandler: completionHandler)
  }
  
  func findUsers(withVkIds vkIds: [String], completionHandler: @escaping ([User]?, Error?) -> Void) {
    FirebaseManager.shared.loadObjects(path: .userData) { (userDictionaries, error) in
      if let userDictionaries = userDictionaries {
        var users: [User] = []
        for userDictionary in userDictionaries {
          if let userVkId = userDictionary["vk_id"] as? String,
            vkIds.contains(userVkId),
            let user = User(dictionary: userDictionary) {
            users.append(user)
          }
        }
        completionHandler(users, nil)
      } else {
        completionHandler(nil, error)
      }
    }
  }
  
  func findUser(withId userId: String, completionHandler: @escaping (User?, Error?) -> Void) {
    FirebaseManager.shared.loadObject(id: userId, path: .userData) { (userDictionary, error) in
      completionHandler(User(dictionary: userDictionary ?? [:]), error)
    }
  }
}
