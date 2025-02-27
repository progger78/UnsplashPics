//
//  CustomStackView.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import UIKit

class CustomStackView: UIView {
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let totalPhotosStackView = TitleValueStackView()
    private let totalCollectionsStackView = TitleValueStackView()
    private let totalLikesStackView = TitleValueStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with user: UserProfile) {
        totalPhotosStackView.configure(with: "Подписчики", value: user.followersCount)
        totalCollectionsStackView.configure(with: "Подписки", value: user.followingCount)
        totalLikesStackView.configure(with: "Лайки", value: user.totalLikes)
    }
}

private extension CustomStackView {
    func initialize() {
        embedViews()
        configureConstraints()
    }
    
    func embedViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews(totalPhotosStackView, totalCollectionsStackView, totalLikesStackView)
    }
    
    func configureConstraints() {
        mainStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
