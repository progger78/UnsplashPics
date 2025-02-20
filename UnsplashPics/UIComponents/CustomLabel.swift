//
//  CustomLabel.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit

import UIKit
import SnapKit

final class CustomLabel: UIView {
    
    enum LabelType {
        case title
        case subtitle
        case secondary
        case custom(font: UIFont, textColor: UIColor, alignment: NSTextAlignment)
    }
    
    private let label = UILabel()
    private let type: LabelType
    private let numberOfLines: Int
    
    // MARK: - Initializer
    init(type: LabelType, numberOfLines: Int = 1) {
        self.type = type
        self.numberOfLines = numberOfLines
        super.init(frame: .zero)
        configureLabel()
        applyStyle(for: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureLabel() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.numberOfLines = numberOfLines
    }
    
    private func applyStyle(for type: LabelType) {
        switch type {
        case .title:
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textColor = .label
            label.textAlignment = .center
            
        case .subtitle:
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .label
            label.textAlignment = .center
            
        case .secondary:
            label.font = .systemFont(ofSize: 18, weight: .regular)
            label.textColor = .label
            label.textAlignment = .left
            
        case .custom(let font, let textColor, let alignment):
            label.font = font
            label.textColor = textColor
            label.textAlignment = alignment
        }
    }
    
    // MARK: - Public Methods
    func set(_ text: String?) {
        label.text = text
    }
    
    func updateStyle(font: UIFont? = nil, textColor: UIColor? = nil, alignment: NSTextAlignment? = nil, backgroundColor: UIColor? = nil) {
        if let font = font {
            label.font = font
        }
        if let textColor = textColor {
            label.textColor = textColor
        }
        if let alignment = alignment {
            label.textAlignment = alignment
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }
}
