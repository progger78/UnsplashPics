//
//  EmptyStateView.swift
//  CryptoInfo
//
//  Created by 1 on 07.12.2024.
//

import UIKit

class EmptyStateView: UIView {
    private let messageLabel = CustomLabel(type: .title, numberOfLines: 3)
    private let iconImageView = UIImageView()
    private let message: String
    
    init(message: String) {
        self.message = message
        super.init(frame: .zero)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .systemBackground
        messageLabel.set(message)
        iconImageView.image = UIImage(systemName: "magnifyingglass")
        iconImageView.tintColor = .systemGray4
        addSubviews(messageLabel, iconImageView)
        setupConstraints()
    }
    
    func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
            make.size.equalTo(100)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
    }
}
