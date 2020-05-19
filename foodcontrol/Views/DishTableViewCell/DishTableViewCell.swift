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
  @IBOutlet private weak var caloriesLabel: UILabel!
  
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
    
    if let imageUrl = viewModel.dish.imageUrl {
      dishImageView.kf.setImage(with: imageUrl, placeholder: nil, options: [.transition(.fade(0.5))])
    } else {
      dishImageView.image = UIImage(named: "dish_placeholder")?.withRenderingMode(.alwaysOriginal)
    }
  }
  
  private func setupLabels() {
    nameLabel.text = viewModel.dish.name
    nameLabel.textColor = UIColor.label
    nameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    
    let caloriesValue = viewModel.dish.getValue(for: .calories, reference: false)
    let caloriesText = NSMutableAttributedString()
    caloriesText.append(NSAttributedString(string: "+\(caloriesValue.roundedString(to: 0))",
                                            attributes: [.font: UIFont.systemFont(ofSize: 20.0, weight: .semibold),
                                                         .foregroundColor: UIColor.label]))
    caloriesText.append(NSAttributedString(string: "\n" + Dish.ValueType.calories.title,
                                            attributes: [.font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
                                                         .foregroundColor: UIColor.additionalGrayDark]))
    caloriesLabel.attributedText = caloriesText
    
    if let weightValue = viewModel.dish.weight {
      volumeLabel.text = "~\(weightValue.roundedString(to: 0))г"
      volumeLabel.textColor = UIColor.additionalGrayDark
      volumeLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    } else {
      volumeLabel.textColor = UIColor.clear
    }
  }
}
