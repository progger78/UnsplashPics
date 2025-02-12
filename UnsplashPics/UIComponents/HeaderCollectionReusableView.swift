//
//  HeaderCollectionReusableView.swift
//  UnsplashPics
//
//  Created by 1 on 12.02.2025.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    static let reuseId = "HeaderView"

    private let titleLabel = CustomLabel(type: .subtitle, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeader()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHeader() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.set(title)
    }
}
