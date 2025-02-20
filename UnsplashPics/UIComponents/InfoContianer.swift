//
//  InfoContianer.swift
//  UnsplashPics
//
//  Created by 1 on 18.02.2025.
//

import UIKit

class InfoContianer: UIView {
    private let nameLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    private let locationLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    private let totalPhotosLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    
    var handleTap: (() -> Void)?
    
    private var asyncImage = AsyncImageView(cornerRadius: 40)
    private var mainColor: UIColor
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    init(mainColor: UIColor = .tertiarySystemBackground) {
        self.mainColor = mainColor
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with photo: DetailPhoto) {
        Task { await asyncImage.setImage(for: photo.user.profileImage.large) }
        nameLabel.set(photo.user.name)
        locationLabel.set("Локация: \(photo.user.location ?? "Нет информации")")
        totalPhotosLabel.set("Всего фото: \(photo.user.totalPhotos)")
    }
    
    private func setupGestRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContainer))
        addGestureRecognizer(recognizer)
    }
    
    @objc private func didTapContainer() {
        handleTap?()
    }
}

private extension InfoContianer {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        setupGestRecognizer()
    }
    
    func configureView() {
        backgroundColor = mainColor
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.masksToBounds = true
    }
    
    func embedViews() {
        addSubviews(stackView)
        stackView.addArrangedSubviews(asyncImage, infoStackView)
        infoStackView.addArrangedSubviews(nameLabel, locationLabel, totalPhotosLabel)
    }
    
    func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        asyncImage.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
    }
}
