//
//  UITextField+Padding.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

extension UITextField {
  func setLeftPaddingPoints(_ amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
    leftView = paddingView
    leftViewMode = .always
  }
  func setRightPaddingPoints(_ amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
    rightView = paddingView
    rightViewMode = .always
  }
}
