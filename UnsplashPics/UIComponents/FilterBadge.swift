//
//  FilterBadge.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit


class FilterBadge: UIView {
    
    private let titleLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    
    private let mainColor: UIColor
    
    init(mainColor: UIColor) {
        self.mainColor = mainColor
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ text: String?, color: UIColor) {
        titleLabel.set(text)
        backgroundColor = color
    }
}

private extension FilterBadge {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        
    }
    
    func configureView() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }
    
    func embedViews() {
        addSubview(titleLabel)
    }
    
    func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
