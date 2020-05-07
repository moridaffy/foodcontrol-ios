//
//  InfoTextTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class InfoTextTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var contentLabel: UILabel!
  
  private var viewModel: InfoTextTableViewCellModel!
  
  func setup(viewModel: InfoTextTableViewCellModel) {
    self.viewModel = viewModel
  
    setupLabels()
  }
  
  private func setupLabels() {
    titleLabel.text = viewModel.type.title
    titleLabel.textColor = UIColor.placeholderText
    titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    
    contentLabel.text = viewModel.text
    contentLabel.textColor = UIColor.label
    contentLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
  }
  
}
