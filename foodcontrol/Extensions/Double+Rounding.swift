//
//  Double+Rounding.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 10.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

extension Double {
  
  /// Округление числа и преобразование в строку
  /// - Parameters:
  ///   - numbers: кол-во цифр после разделителя
  ///   - absolute: если true, то берется число по модулю
  ///   - removeZeros: если true, то число 10.0 будет отображено как 10
  ///   - separator: разделитель между целыми и десятичными
  func roundedString(to numbers: Int, absolute: Bool = false, removeZeros: Bool = true, separator: String = ".") -> String {
    let divisor = pow(10.0, Double(numbers))
    var number = (self * divisor).rounded() / divisor
    if absolute {
      number = abs(number)
    }
    
    if number == Double(Int(number)) && removeZeros {
      return "\(Int(number))"
    } else if separator == "." {
      return "\(number)"
    } else {
      return "\(number)".replacingOccurrences(of: ".", with: separator)
    }
  }
  
}
