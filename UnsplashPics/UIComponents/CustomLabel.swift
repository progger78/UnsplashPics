//
//  CustomLabel.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit

class CustomLabel: UIView {
    
    enum LabelType {
        case title
        case subtitle
        case secondary
    }
    
    private let type: LabelType
    private let numberOfLines: Int
    
    let label = UILabel()
    
    init(type: LabelType, numberOfLines: Int) {
        self.type = type
        self.numberOfLines = numberOfLines
        super.init(frame: .zero)
        configure()
        setupTitle(with: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitle(with type: LabelType) {
        label.textColor = .label
        label.numberOfLines = numberOfLines
        
        switch type {
        case .title:
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textAlignment = .center
        case .subtitle:
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textAlignment = .center
        case .secondary:
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.textAlignment = .left
        }
    }
    private func configure() {
        addSubview(label)
        label.turnOffTAMIC()
        label.equalToSuperview(view: self)
    }
    
    func set(_ text: String) {
        label.text = text
    }
}
