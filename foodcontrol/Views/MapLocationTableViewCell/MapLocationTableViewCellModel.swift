//
//  MapLocationTableViewCellModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation
import CoreLocation

class MapLocationTableViewCellModel: FCTableViewCellModel {
  
  let coordinate: CLLocationCoordinate2D
  
  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }
  
}
