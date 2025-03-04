//
//  Array+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import Foundation

extension Array {
    mutating func appendWithLimit(_ element: Element, limit: Int) {
        if count >= limit {
            removeFirst()
        }
        append(element)
    }
    
    subscript(safe index: Int) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
