//
//  String+Size.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 15.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import UIKit

extension String {
    func height(width: CGFloat, attributes: [NSAttributedString.Key: Any]?) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(height: CGFloat, attributes: [NSAttributedString.Key: Any]?) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(boundingBox.width)
    }
}

