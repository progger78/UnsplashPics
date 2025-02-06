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
        contentView.addSubview(asyncImageView)
    }
    
    func configureConstraints() {
        asyncImageView.translatesAutoresizingMaskIntoConstraints = false
        asyncImageView.equalToSuperview(view: contentView)
    }
}
