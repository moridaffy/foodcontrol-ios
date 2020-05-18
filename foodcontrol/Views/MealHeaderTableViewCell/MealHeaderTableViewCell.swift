//
//  MealHeaderTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 05.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

class MealHeaderTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var headerContainerView: UIView!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var calloriesLabel: UILabel!
  
  private var viewModel: MealHeaderTableViewCellModel!
  
  func setup(viewModel: MealHeaderTableViewCellModel) {
    self.viewModel = viewModel
    
    selectionStyle = .none
    
    setupShadow()
    setupLabels()
  }
  
  private func setupShadow() {
    headerContainerView.backgroundColor = UIColor.white
    headerContainerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
    headerContainerView.layer.shadowOpacity = 0.25
    headerContainerView.layer.shadowOffset = CGSize(width: 0.0, height: -10.0)
    headerContainerView.layer.shadowRadius = 5.0
  }
  
  private func setupLabels() {
    let dateText = NSMutableAttributedString()
    dateText.append(NSAttributedString(string: viewModel.dateDayMonthString + " ",
                                       attributes: [.font: UIFont.systemFont(ofSize: 30.0, weight: .semibold),
                                                    .foregroundColor: UIColor.label]))
    dateText.append(NSAttributedString(string: NSLocalizedString("в", comment: "") + " " + viewModel.dateTimeString,
                                       attributes: [.font: UIFont.systemFont(ofSize: 20.0, weight: .regular),
                                                    .foregroundColor: UIColor.additionalGrayDark]))
    dateLabel.attributedText = dateText
    
    calloriesLabel.text = "+\(viewModel.meal.totalCallories.roundedString(to: 1, removeZeros: true))"
    calloriesLabel.textColor = UIColor.label
    calloriesLabel.font = UIFont.systemFont(ofSize: 26.0, weight: .semibold)
  }
  
}
