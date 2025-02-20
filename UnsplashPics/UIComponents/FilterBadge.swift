//
//  FilterBadge.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit


final class FilterBadge: UIView {
    
    private let titleLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    
    var mainColor: UIColor?
    
    var borderColor: UIColor = .systemGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    init() {
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
        layer.borderColor = borderColor.cgColor
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
