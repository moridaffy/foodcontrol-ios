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
  @IBOutlet private weak var textView: UITextView!
  @IBOutlet private weak var textViewPlaceholderLabel: UILabel!
  @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
  
  private var viewModel: InfoTextTableViewCellModel!
  private weak var delegate: InfoTextTableViewCellDelegate?
  
  func setup(viewModel: InfoTextTableViewCellModel, delegate: InfoTextTableViewCellDelegate? = nil) {
    self.viewModel = viewModel
    self.delegate = delegate
  
    selectionStyle = .none
    
    setupLabels()
  }
  
  private func setupLabels() {
    titleLabel.text = viewModel.type.title
    titleLabel.textColor = UIColor.placeholderText
    titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    
    let textViewFont = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    let textViewText = viewModel.text ?? ""
    let textViewHeight = textViewText.height(width: UIScreen.main.bounds.width - 32.0,
                                             attributes: [.font: textViewFont])
    textViewHeightConstraint.constant = max(31.0, textViewHeight + 8.0)
    textView.text = textViewText
    textView.textColor = UIColor.label
    textView.font = textViewFont
    textView.delegate = self
    textView.isScrollEnabled = false
    textView.isUserInteractionEnabled = viewModel.editable
    textView.textContainer.lineFragmentPadding = 0.0
    textView.backgroundColor = UIColor.clear
    
    textViewPlaceholderLabel.font = textViewFont
    textViewPlaceholderLabel.text = viewModel.type.placeholder
    textViewPlaceholderLabel.textColor = UIColor.placeholderText
    textViewPlaceholderLabel.isUserInteractionEnabled = false
    textViewPlaceholderLabel.isHidden = !textViewText.isEmpty
  }
}

extension InfoTextTableViewCell: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard text == "\n" else { return true }
    textView.endEditing(true)
    return false
  }
  
  func textViewDidChange(_ textView: UITextView) {
    let textViewText = textView.text ?? ""
    textViewPlaceholderLabel.isHidden = !textViewText.isEmpty
    delegate?.textValueChanged(textViewText, type: viewModel.type)
  }
}
