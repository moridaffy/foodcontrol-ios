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
    
    let dailyCaloryAmount = calculateDailyCaloryAmount(weightPlan: weightPlan, activity: activity, sex: sex, weight: weight)
    
    DBManager.shared.updateUser(user: user,
                                weightPlanValue: weightPlan.rawValue,
                                activityValue: activity.rawValue,
                                sexValue: sex.rawValue,
                                weight: weight,
                                dailyCaloryAmount: dailyCaloryAmount) { success in
      guard success else { return }
      FirebaseManager.shared.uploadObject(user) { (error) in
        completionHandler(error)
        if error == nil {
          AuthManager.shared.switchToMainWorkflow()
        }
      }
    }
  }
  
  private func calculateDailyCaloryAmount(weightPlan: User.WeightPlanType, activity: User.ActivityType, sex: User.SexType, weight: Double) -> Double {
    var minValue: Double = 0.0
    
    let height: Double = 175.0
    let age: Double = 30.0
    var value: Double = {
      switch sex {
      case .male:
        minValue = 1600.0
        return 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age)
      case .female:
        minValue = 1200.0
        return 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age)
      default:
        return 0.0
      }
    }()
    
    switch activity {
    case .lowActivity:
      value = value * 1.2
    case .mediumActivity:
      value = value * 1.5
    case .highActivity:
      value = value * 1.9
    default:
      break
    }
    
    switch weightPlan {
    case .loseWeight:
      let newValue = value * 0.9
      value = max(minValue, newValue)
    case .keepWeight:
      value = max(minValue, value)
    case .gainWeight:
      let newValue = value * 1.2
      value = max(minValue, newValue)
    default:
      break
    }
    
    return value
  }
}
