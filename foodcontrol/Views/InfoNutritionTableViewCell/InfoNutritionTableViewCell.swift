//
//  InfoNutritionTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class InfoNutritionTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var proteinsTitleLabel: UILabel!
  @IBOutlet private weak var proteinsValueLabel: UILabel!
  @IBOutlet private weak var fatsTitleLabel: UILabel!
  @IBOutlet private weak var fatsValueLabel: UILabel!
  @IBOutlet private weak var carbohydrateTitleLabel: UILabel!
  @IBOutlet private weak var carbohydrateValueLabel: UILabel!
  @IBOutlet private weak var calloriesTitleLabel: UILabel!
  @IBOutlet private weak var calloriesValueLabel: UILabel!
  
  private var viewModel: InfoNutritionTableViewCellModel!
  
  func setup(viewModel: InfoNutritionTableViewCellModel) {
    self.viewModel = viewModel
    
    setupLabels()
  }
  
  private func setupLabels() {
    titleLabel.text = NSLocalizedString("Питательная ценность", comment: "")
    titleLabel.textColor = UIColor.placeholderText
    titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    
    for i in 0..<InfoNutritionTableViewCellModel.InfoUnit.allUnits.count {
      let titleLabel = [proteinsTitleLabel, fatsTitleLabel, carbohydrateTitleLabel, calloriesTitleLabel][i]
      let valueLabel = [proteinsValueLabel, fatsValueLabel, carbohydrateValueLabel, calloriesValueLabel][i]
      let unit = InfoNutritionTableViewCellModel.InfoUnit.allUnits[i]
      
      titleLabel?.text = unit.title
      titleLabel?.textColor = UIColor.label
      titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
      
      let valueLabelText = NSMutableAttributedString()
      valueLabelText.append(NSAttributedString(string: "\(viewModel.getUnitValue(reference: false, unit: unit))\(unit.unit) ",
        attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .regular),
                     .foregroundColor: UIColor.label]))
      valueLabelText.append(NSAttributedString(string: "(\(viewModel.getUnitValue(reference: true, unit: unit))\(unit.unit) / 100г)",
        attributes: [.font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
                     .foregroundColor: UIColor.placeholderText]))
      valueLabel?.attributedText = valueLabelText
    }
  }
}
