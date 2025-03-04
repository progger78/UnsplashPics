//
//  CustomStackView.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import UIKit

class CustomStackView: UIView {
    
    enum CustomStackViewAction {
        case followers
        case following
    }
    
    var handleTap: ((CustomStackViewAction) -> Void)?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let totalFollowersStackView = TitleValueStackView()
    private let totalFollowingsStackView = TitleValueStackView()
    private let totalLikesStackView = TitleValueStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with user: UserProfile) {
        totalFollowersStackView.configure(with: "Подписчики", value: user.followersCount)
        totalFollowingsStackView.configure(with: "Подписки", value: user.followingCount)
        totalLikesStackView.configure(with: "Лайки", value: user.totalLikes)
    }
    
    private func setupHandlers() {
        totalFollowersStackView.handleTap = { [weak self] in
            self?.handleTap?(.followers)
        }
        
        totalFollowingsStackView.handleTap = { [weak self] in
            self?.handleTap?(.following)
        }
    }
}

private extension CustomStackView {
    func initialize() {
        embedViews()
        configureConstraints()
        setupHandlers()
    }
    
    func embedViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews(totalFollowersStackView, totalFollowingsStackView, totalLikesStackView)
    }
    
    func configureConstraints() {
        mainStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
