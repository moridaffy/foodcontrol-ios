//
//  ProfileSetupViewModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

class ProfileSetupViewModel {
  
  var selectedWeightPlan: User.WeightPlanType?
  var selectedActivity: User.ActivityType?
  var selectedSex: User.SexType?
  
  func getHelpText(for index: Int) -> String? {
    switch index {
    case 1:
      return NSLocalizedString("Укажите ваш текущий вес - это будет Ваша отправная точка. По окончанию каждой недели Вы будете получать отчет о результатах питания на протяжении всей недели, а также график изменения Вашего веса", comment: "")
    case 2:
      return NSLocalizedString("Выберите, что вы хотите сделать со своим текущим весом: немного сбросить лишнего, поддерживать себя в идеальной текущей форме или немного поднабрать?", comment: "")
    case 3:
      return NSLocalizedString("Укажите, какой у Вас примерный уровень активности: высокий (тренировки каждый день), средний (тренировки 2-3 раза в неделю) или низкий (не тренируетесь)?", comment: "")
    case 4:
      return NSLocalizedString("Укажите, какой Ваш пол: мужской или женский?", comment: "")
    default:
      return nil
    }
  }
  
  func setupProfile(weightPlan: User.WeightPlanType, activity: User.ActivityType, sex: User.SexType, weight: Double, completionHandler: @escaping (Error?) -> Void) {
    guard let user = AuthManager.shared.currentUser else {
      completionHandler(nil)
      return
    }
    
    DBManager.shared.updateUser(user: user, weightPlanValue: weightPlan.rawValue, activityValue: activity.rawValue, weight: weight) { success in
      guard success else { return }
      FirebaseManager.shared.uploadObject(user) { (error) in
        completionHandler(error)
        if error == nil {
          AuthManager.shared.switchToMainWorkflow()
        }
      }
    }
  }
}
