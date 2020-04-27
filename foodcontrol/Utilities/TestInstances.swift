//
//  TestInstances.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

struct TestInstances {
  
  static let longText: String = """
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  """
  
  static let dishes: [Dish] = [
    Dish(name: "Бигмак", imageUrl: URL(string: "https://nashagazeta.ch/sites/default/files/styles/article/public/bur-bigmac-big_0.jpg?itok=zA971F50")),
    Dish(name: "Бефстроганов", imageUrl: URL(string: "https://art-lunch.ru/content/uploads/2016/04/Beef_Stroganoff.jpg")),
    Dish(name: "Картошка фри", imageUrl: URL(string: "https://img.povar.ru/main/64/12/b0/54/kartofel_fri_v_domashnih_usloviyah-36496.jpg")),
    Dish(name: "Мятный милкшейк", imageUrl: URL(string: "https://peopleofdesign.ru/obzors/straw-for-mcdonalds-0.jpg"))
  ]
  
  static let meals: [Meal] = [
    Meal(dishes: dishes)
  ]
}
