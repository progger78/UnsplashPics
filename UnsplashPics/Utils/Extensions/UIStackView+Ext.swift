//
//  UIStackView+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 18.02.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
