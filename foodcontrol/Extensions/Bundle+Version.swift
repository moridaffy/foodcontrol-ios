//
//  Bundle+Version.swift
//  foodcontrol
//
//  Created by Maxim Skryabin on 17.05.2020.
//  Copyright © 2020 MSKR. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
