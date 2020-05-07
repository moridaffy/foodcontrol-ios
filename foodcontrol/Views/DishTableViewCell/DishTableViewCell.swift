//
//  DishTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit
import Kingfisher

class DishTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var dishImageView: UIImageView!
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var volumeLabel: UILabel!
  @IBOutlet private weak var calloriesLabel: UILabel!
  
  private var viewModel: DishTableViewCellModel!
  
  func setup(viewModel: DishTableViewCellModel) {
    self.viewModel = viewModel
    
    setupImage()
    setupLabels()
  }
  
  private func setupImage() {
    dishImageView.layer.cornerRadius = 10.0
    dishImageView.layer.masksToBounds = true
    dishImageView.contentMode = .scaleAspectFill
    dishImageView.backgroundColor = UIColor.additionalGrayLight
    dishImageView.kf.setImage(with: viewModel.dish.imageUrl, placeholder: nil, options: [.transition(.fade(0.5))])
  }
  
  private func setupLabels() {
    nameLabel.text = viewModel.dish.name
    nameLabel.textColor = UIColor.label
    nameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    volumeLabel.text = "~300г"
    volumeLabel.textColor = UIColor.additionalGrayDark
    volumeLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    
    let calloriesText = NSMutableAttributedString()
    calloriesText.append(NSAttributedString(string: "+150",
                                            attributes: [.font: UIFont.systemFont(ofSize: 20.0, weight: .semibold),
                                                         .foregroundColor: UIColor.label]))
    calloriesText.append(NSAttributedString(string: "\n" + NSLocalizedString("ккал", comment: ""),
                                            attributes: [.font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
                                                         .foregroundColor: UIColor.additionalGrayDark]))
    
    calloriesLabel.attributedText = calloriesText
  }
}
