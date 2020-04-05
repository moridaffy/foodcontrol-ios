//
//  CreateMealViewControllerModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation
import CoreLocation

class CreateMealViewControllerModel {
  let cellModels: [FCTableViewCellModel] = [
    MealHeaderTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel(),
    DishTableViewCellModel(),
    BigButtonTableViewCellModel(type: .addDish),
    MapLocationTableViewCellModel(coordinate: CLLocationCoordinate2D(latitude: 55.766041, longitude: 37.684551))
  ]
}
