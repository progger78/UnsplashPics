//
//  Number+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 25.02.2025.
//

import Foundation


extension Numeric where Self: Comparable {
    func formatNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        let number = Double("\(self)") ?? 0
        
        if number >= 1000 {
            let value = number / 1000
            return "\(Int(value))K"
        } else {
            return "\(self)"
        }
    }
}
