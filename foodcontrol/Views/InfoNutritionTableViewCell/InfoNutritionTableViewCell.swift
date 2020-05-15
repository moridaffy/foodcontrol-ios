//
//  InfoNutritionTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

protocol InfoNutritionTableViewCellDelegate: class {
  func didChangeNutritionValue(_ value: String, type: InfoNutritionTableViewCell.TextFieldType)
}

class InfoNutritionTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var proteinsTitleLabel: UILabel!
  @IBOutlet private weak var proteinsTextField: UITextField!
  @IBOutlet private weak var proteinsUnitLabel: UILabel!
  @IBOutlet private weak var fatsTitleLabel: UILabel!
  @IBOutlet private weak var fatsTextField: UITextField!
  @IBOutlet private weak var fatsUnitLabel: UILabel!
  @IBOutlet private weak var carbohydrateTitleLabel: UILabel!
  @IBOutlet private weak var carbohydrateTextField: UITextField!
  @IBOutlet private weak var carbohydrateUnitLabel: UILabel!
  @IBOutlet private weak var calloriesTitleLabel: UILabel!
  @IBOutlet private weak var calloriesTextField: UITextField!
  @IBOutlet private weak var calloriesUnitLabel: UILabel!
  
  private var viewModel: InfoNutritionTableViewCellModel!
  private weak var delegate: InfoNutritionTableViewCellDelegate?
  
  func setup(viewModel: InfoNutritionTableViewCellModel, delegate: InfoNutritionTableViewCellDelegate?) {
    self.viewModel = viewModel
    self.delegate = delegate
    
    selectionStyle = .none
    
    setupLabels()
  }
  
  private func setupLabels() {
    titleLabel.text = NSLocalizedString("Питательная ценность", comment: "")
    titleLabel.textColor = UIColor.placeholderText
    titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    
    for i in 0..<Dish.ValueType.allUnits.count {
      let titleLabel = [proteinsTitleLabel, fatsTitleLabel, carbohydrateTitleLabel, calloriesTitleLabel][i]
      let valueTextField = [proteinsTextField, fatsTextField, carbohydrateTextField, calloriesTextField][i]
      let unitLabel = [proteinsUnitLabel, fatsUnitLabel, carbohydrateUnitLabel, calloriesUnitLabel][i]
      let unit = Dish.ValueType.allUnits[i]

      titleLabel?.text = unit.title
      titleLabel?.textColor = UIColor.label
      titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
      
      valueTextField?.text = "\(viewModel.getUnitValue(reference: false, unit: unit))\(unit.unit) "
      valueTextField?.textColor = UIColor.label
      valueTextField?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
      valueTextField?.backgroundColor = UIColor.clear
      valueTextField?.isUserInteractionEnabled = viewModel.editable
      valueTextField?.delegate = self
      valueTextField?.tag = i + 1
      valueTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
      valueTextField?.textAlignment = .right
      
      unitLabel?.text = "(\(viewModel.getUnitValue(reference: true, unit: unit))\(unit.unit) / 100г)"
      unitLabel?.textColor = UIColor.placeholderText
      unitLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    }
  }
  
  @objc private func textFieldEditingChanged(_ textField: UITextField) {
    guard let textFieldType = TextFieldType(rawValue: textField.tag) else { return }
    delegate?.didChangeNutritionValue(textField.text ?? "", type: textFieldType)
  }
}

extension InfoNutritionTableViewCell: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return false
  }
}

extension InfoNutritionTableViewCell {
  enum TextFieldType: Int {
    case proteins = 1
    case fats = 2
    case carbohydrates = 3
    case callories = 4
  }
}
