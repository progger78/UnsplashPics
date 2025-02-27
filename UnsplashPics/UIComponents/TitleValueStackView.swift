//
//  TitleValueStackView.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import UIKit

class TitleValueStackView: UIView {

    var handleTap: (() -> Void)?
    
    private let titleLabel = CustomLabel(type: .subtitle, numberOfLines: 1)
    private let valueLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, value: Int) {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.addArrangedSubviews(titleLabel, valueLabel)
        titleLabel.set(title)
        valueLabel.set(String(value))
    }
    
    private func setupGestRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContainer))
        addGestureRecognizer(recognizer)
    }
    
    @objc private func didTapContainer() {
        handleTap?()
    }
}
