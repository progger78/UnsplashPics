//
//  Int+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 18.02.2025.
//

import Foundation


extension Numeric where Self: LosslessStringConvertible {
    func toString() -> String? {
        return String(self)
    }
}
