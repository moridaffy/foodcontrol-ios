//
//  BigButtonTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class BigButtonTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var buttonContainerView: UIView!
  @IBOutlet private weak var buttonTitleContainerView: UIView!
  @IBOutlet private weak var buttonTitleContainerImageView: UIImageView!
  @IBOutlet private weak var buttonTitleContainerLabel: UILabel!
  
  private var viewModel: BigButtonTableViewCellModel!
  
  func setup(viewModel: BigButtonTableViewCellModel) {
    self.viewModel = viewModel
    
    setupContainers()
    setupTitle()
  }
  
  private func setupContainers() {
    buttonContainerView.backgroundColor = UIColor.white
    buttonContainerView.layer.cornerRadius = 10.0
    buttonContainerView.layer.masksToBounds = true
    buttonContainerView.layer.borderColor = UIColor.additionalGray.cgColor
    buttonContainerView.layer.borderWidth = 1.0
    buttonTitleContainerView.backgroundColor = UIColor.clear
  }
  
  private func setupTitle() {
    buttonTitleContainerImageView.image = UIImage(systemName: viewModel.type.iconName)?.withRenderingMode(.alwaysTemplate)
    buttonTitleContainerImageView.tintColor = UIColor.additionalYellow
    buttonTitleContainerLabel.text = viewModel.type.title
    buttonTitleContainerLabel.textColor = UIColor.additionalYellow
    buttonTitleContainerLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
  }
}
