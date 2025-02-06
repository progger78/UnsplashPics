//
//  MainSearchCollectionViewCell.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit

final class MainSearchCollectionViewCell: UICollectionViewCell {
    static let reuseId = "MainSearchCollectionViewCell"
    
    let asyncImageView = AsyncImageView()
    let descriptionLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    let createdAtLabel = CustomLabel(type: .secondary, numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        asyncImageView.image = nil 
    }
    
    func configure(with photo: UnsplashPhoto) {
        Task { await asyncImageView.setImage(for: photo.urls.small) }
        descriptionLabel.set("Likes: \(photo.likes)")
        createdAtLabel.set("Created at: \(photo.formattedDate ?? "Wrong format")")
    }
}

private extension MainSearchCollectionViewCell {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = .systemBackground
    }
    
    func embedViews() {
        contentView.addSubviews(asyncImageView, descriptionLabel, createdAtLabel)
    }
    
    func configureConstraints() {
        [asyncImageView, descriptionLabel, createdAtLabel].forEach { $0.turnOffTAMIC() }
        asyncImageView.equalToSuperview(view: contentView, hasBottomAnchor: false)
        
        NSLayoutConstraint.activate([
            asyncImageView.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionLabel.topAnchor.constraint(equalTo: asyncImageView.bottomAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            createdAtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            createdAtLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            createdAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }

}
