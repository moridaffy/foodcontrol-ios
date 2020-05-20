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
  }
  
}
