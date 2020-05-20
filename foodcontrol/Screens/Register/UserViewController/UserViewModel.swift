//
//  ProfileViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 20.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class UserViewModel {
  
  let user: User
  
  weak var view: UserViewController?
  
  init(user: User) {
    self.user = user
  }
  
}
