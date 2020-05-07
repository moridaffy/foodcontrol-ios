//
//  BigImageTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import Kingfisher

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
    bigImageView.contentMode = .scaleAspectFill
    
    if let url = viewModel.url {
      bigImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.5))])
    } else if let image = viewModel.image {
      bigImageView.image = image
    } else {
      // TODO: placeholder
    }
  }
  
}
