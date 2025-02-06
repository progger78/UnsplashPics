//
//  UIView+Ext.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit


extension UIView {
    func equalToSuperview(view: UIView, hasTopAnchor: Bool = true, hasBottomAnchor: Bool = true) {
        var constraints: [NSLayoutConstraint] = [
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        if hasTopAnchor {
            constraints.append(view.topAnchor.constraint(equalTo: topAnchor))
        }
        
        if hasBottomAnchor {
            constraints.append(view.bottomAnchor.constraint(equalTo: bottomAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func turnOffTAMIC() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
