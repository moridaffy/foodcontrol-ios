//
//  InfoTextTableViewCell.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 27.04.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

protocol InfoTextTableViewCellDelegate: class {
  func textValueChanged(_ value: String, type: InfoTextTableViewCellModel.InfoType)
}

class InfoTextTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var textField: UITextField!
  
  private var viewModel: InfoTextTableViewCellModel!
  private weak var delegate: InfoTextTableViewCellDelegate?
  
  func setup(viewModel: InfoTextTableViewCellModel, delegate: InfoTextTableViewCellDelegate?) {
    self.viewModel = viewModel
    self.delegate = delegate
  
    selectionStyle = .none
    
    setupLabels()
  }
  
  private func setupLabels() {
    titleLabel.text = viewModel.type.title
    titleLabel.textColor = UIColor.placeholderText
    titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    
    textField.text = viewModel.text
    textField.textColor = UIColor.label
    textField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    textField.backgroundColor = .clear
    textField.placeholder = viewModel.type.placeholder
    textField.delegate = self
    textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    textField.isUserInteractionEnabled = viewModel.editable
  }
  
  @objc private func textFieldEditingChanged() {
    delegate?.textValueChanged(textField.text ?? "", type: viewModel.type)
  }
}

extension InfoTextTableViewCell: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return false
  }
}
