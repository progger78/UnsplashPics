//
//  UserProfileView.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import UIKit

class UserProfileView: UIView {

    let profileImageView = AsyncImageView(cornerRadius: 70, hasBorderColor: true)
    
    init() {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        Task { await profileImageView.setImage(for: user.profileImage.large ) }
    }
}



private extension UserProfileView {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func embedViews() {
        addSubviews(profileImageView)
    }
    
    func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }
    }
}
