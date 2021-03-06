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
  @IBOutlet private weak var caloriesTitleLabel: UILabel!
  @IBOutlet private weak var caloriesTextField: UITextField!
  @IBOutlet private weak var caloriesUnitLabel: UILabel!
  
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
      let titleLabel = [proteinsTitleLabel, fatsTitleLabel, carbohydrateTitleLabel, caloriesTitleLabel][i]
      let valueTextField = [proteinsTextField, fatsTextField, carbohydrateTextField, caloriesTextField][i]
      let unitLabel = [proteinsUnitLabel, fatsUnitLabel, carbohydrateUnitLabel, caloriesUnitLabel][i]
      let unit = Dish.ValueType.allUnits[i]

      titleLabel?.text = unit.title
      titleLabel?.textColor = UIColor.label
      titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
      
      valueTextField?.keyboardType = .numberPad
      valueTextField?.placeholder = "\(Int.random(in: 1...99))"
      valueTextField?.textColor = UIColor.label
      valueTextField?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
      valueTextField?.backgroundColor = UIColor.clear
      valueTextField?.isUserInteractionEnabled = viewModel.editable
      valueTextField?.delegate = self
      valueTextField?.tag = i + 1
      valueTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
      valueTextField?.textAlignment = .right
      
      var valueText: String = ""
      let unitText = NSMutableAttributedString()
      let value = viewModel.dish.getValue(for: unit, reference: false)
      let referenceValue = viewModel.dish.getValue(for: unit, reference: true)
      
      if viewModel.editable {
        valueText = (value == 0.0) ? "" : value.roundedString(to: 1, separator: ",")
        
        unitText.append(NSAttributedString(string: unit.unit, attributes: [
          .font: UIFont.systemFont(ofSize: 17.0, weight: .regular),
          .foregroundColor: UIColor.label
        ]))
        unitText.append(NSAttributedString(string: " в 100г", attributes: [
          .font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
          .foregroundColor: UIColor.placeholderText
        ]))
      } else {
        valueText = value.roundedString(to: 1, separator: ",")
        
        unitText.append(NSAttributedString(string: unit.unit, attributes: [
          .font: UIFont.systemFont(ofSize: 17.0, weight: .regular),
          .foregroundColor: UIColor.label
        ]))
        unitText.append(NSAttributedString(string: " (\(referenceValue.roundedString(to: 1, separator: ","))\(unit.unit) в 100г)", attributes: [
          .font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
          .foregroundColor: UIColor.placeholderText
        ]))
      }
      
      valueTextField?.text = valueText
      unitLabel?.attributedText = unitText
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
    case calories = 4
  }
}
