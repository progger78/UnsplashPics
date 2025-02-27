//
//  UserCollectionTableViewCell.swift
//  UnsplashPics
//
//  Created by 1 on 25.02.2025.
//

import UIKit

class UserCollectionTableViewCell: UITableViewCell {

    static let reuseId = "UserCollectionTableViewCell"
    let asyncImageView = AsyncImageView(cornerRadius: 15, hasBorderColor: false )
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    let titleLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    let photosCountLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    let lastUpdatedLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.set(nil)
        photosCountLabel.set(nil)
        lastUpdatedLabel.set(nil)
        asyncImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with collection: UserCollection) {
        let title = collection.title
        let totalPhotos = "Всего фото: \(collection.totalPhotos)"
        let lastUpdated = "Обновлена: \(collection.lastUpdated ?? "")"
        Task { await asyncImageView.setImage(for: collection.coverPhoto.urls.small) }
        titleLabel.set(title)
        photosCountLabel.set(totalPhotos)
        lastUpdatedLabel.set(lastUpdated)
    }
}

private extension UserCollectionTableViewCell {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        contentView.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    func embedViews() {
        contentView.addSubviews(asyncImageView, stackView)
        stackView.addArrangedSubviews(titleLabel, photosCountLabel, lastUpdatedLabel)
    }
    
    func configureConstraints() {
        asyncImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(asyncImageView.snp.trailing).offset(10)
            make.top.trailing.bottom.equalToSuperview().inset(10)
        }
    }
}
