//
//  UIView+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit


extension UIView {

    func equalToSuperview(view: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
