//
//  String+Validation.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 11.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

extension String {
  func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: self)
  }
  
  func isValidPassword() -> Bool {
    guard !isEmpty || self == "" else { return false }
    guard count >= 6 else { return false }
    return true
  }
  
  func isValidUsername() -> Bool {
    guard count >= 3 else { return false }
    return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
  }
}
