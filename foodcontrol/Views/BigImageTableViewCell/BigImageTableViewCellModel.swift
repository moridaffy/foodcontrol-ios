//
//  BigImageTableViewCellModel.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class BigImageTableViewCellModel: FCTableViewCellModel {
  
  let url: URL?
  let image: UIImage?
  
  init(url: URL? = nil, image: UIImage? = nil) {
    self.url = url
    self.image = image
  }
  
}
