//
//  BigImageTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class BigImageTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var bigImageView: UIImageView!
  
  private var viewModel: BigImageTableViewCellModel!
  
  func setup(viewModel: BigImageTableViewCellModel) {
    self.viewModel = viewModel
    
    setupImageView()
  }
  
  private func setupImageView() {
    bigImageView.layer.cornerRadius = 10.0
    bigImageView.layer.masksToBounds = true
    bigImageView.layer.borderColor = UIColor.additionalGray.cgColor
    bigImageView.layer.borderWidth = 1.0
    
    if let url = viewModel.url {
      // TODO: loading image with Kingfisher
    } else if let image = viewModel.image {
      bigImageView.image = image
    } else {
      // TODO: placeholder
    }
  }
  
}
