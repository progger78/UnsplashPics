//
//  CustomBackgroundView.swift
//  UnsplashPics
//
//  Created by 1 on 22.02.2025.
//

import UIKit

class CustomBackgroundView: UIView {
    enum MaskedCornersTypes {
        case upperCorners
        case bottomCorners
        case none
    }
    
    let mainBackgroundColor: UIColor
    let cornerRadius: CGFloat
    let maskedCornersType: MaskedCornersTypes
    
    init(mainBackgroundColor: UIColor, 
         cornerRadius: CGFloat,
         maskedCorners: MaskedCornersTypes = .none) {
        self.mainBackgroundColor = mainBackgroundColor
        self.cornerRadius = cornerRadius
        self.maskedCornersType = maskedCorners
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = mainBackgroundColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        layer.maskedCorners = setupCorners()
    }
    
    func setupCorners() -> CACornerMask {
        switch maskedCornersType {
        case .upperCorners:
            [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case .bottomCorners:
            [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .none:
            []
        }
    }
}
