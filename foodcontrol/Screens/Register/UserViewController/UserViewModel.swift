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
  var isCurrentUser: Bool {
    return user.id == AuthManager.shared.currentUser?.id
  }
  var isFollowingUser: Bool {
    guard let currentUser = AuthManager.shared.currentUser else { return false }
    return currentUser.friendIds.contains(user.id)
  }
  private(set) var meals: [Meal] = [] {
    didSet {
      view?.reloadTableView()
    }
  }
  
  weak var view: UserViewController?
  
  init(user: User, meals: [Meal]? = nil) {
    self.user = user
    self.meals = meals ?? []
    
    if meals == nil {
      getUsersMeals()
    }
  }
  
  private func getUsersMeals() {
    FirebaseManager.shared.getUsersMeals(userId: user.id) { [weak self] (meals, error) in
      if let meals = meals {
        self?.meals = meals
      } else {
        self?.view?.showAlertError(error: error,
                                   desc: NSLocalizedString("Не удалось загрузить информацию о пользователе", comment: ""),
                                   critical: false)
      }
    }
  }
  
  func updateUser(weightPlan: User.WeightPlanType? = nil, activity: User.ActivityType? = nil, sex: User.SexType? = nil, weight: Double? = nil) {
    let newDailyAmount = user.calculateDailyCalorieAmount(weightPlan: weightPlan, activity: activity, sex: sex, weight: weight)
    DBManager.shared.updateUser(user: user, weightPlanValue: weightPlan?.rawValue, activityValue: activity?.rawValue, sexValue: sex?.rawValue, weight: weight, dailyCaloryAmount: newDailyAmount) { (_) in
      FirebaseManager.shared.uploadObject(self.user) { [weak self] (error) in
        if let error = error {
          self?.view?.showAlertError(error: error,
                                     desc: NSLocalizedString("Не удалось обновить данные о пользователе", comment: ""),
                                     critical: false)
        } else {
          self?.view?.reloadTableView()
        }
      }
    }
  }
  
  func addFriend(completionHandler: @escaping (Error?) -> Void) {
    guard !isFollowingUser else {
      completionHandler(nil)
      return
    }
    guard let currentUser = AuthManager.shared.currentUser else { return }
    var newFriendIds = Array(currentUser.friendIds)
    newFriendIds.append(user.id)
    
    DBManager.shared.updateUser(user: currentUser, friendIds: newFriendIds) { (success) in
      guard success else { return }
      FirebaseManager.shared.uploadObject(currentUser, merge: true, completionHandler: completionHandler)
    }
  }
  
  func removeFriend(completionHandler: @escaping (Error?) -> Void) {
    guard isFollowingUser else {
      completionHandler(nil)
      return
    }
    guard let currentUser = AuthManager.shared.currentUser,
      let friendIdIndex = currentUser.friendIds.firstIndex(where: { $0 == user.id }) else { return }
    var newFriendIds = Array(currentUser.friendIds)
    newFriendIds.remove(at: friendIdIndex)
    
    DBManager.shared.updateUser(user: currentUser, friendIds: newFriendIds) { (success) in
      guard success else { return }
      FirebaseManager.shared.uploadObject(currentUser, merge: true, completionHandler: completionHandler)
    }
  }
  
  func logout() {
    DBManager.shared.deleteAll()
    AuthManager.shared.switchToAuthWorkflow()
  }
}
