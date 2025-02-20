//
//  MainSearchCollectionViewCell.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit
import SnapKit

final class MainSearchCollectionViewCell: UICollectionViewCell {
    static let reuseId = "MainSearchCollectionViewCell"
    
    let asyncImageView = AsyncImageView()
    let descriptionLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    let createdAtLabel = CustomLabel(type: .secondary, numberOfLines: 2)
    private(set) var heightConstraint: Constraint?
    
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
    
    func configure(with photo: UnsplashPhoto, photoHeight: CGFloat) {
        Task { await asyncImageView.setImage(for: photo.urls.small) }
        descriptionLabel.set("Likes: \(photo.likes)")
        createdAtLabel.set("Created at: \(photo.formattedDate ?? "Wrong format")")
        
        heightConstraint?.update(offset: photoHeight)
        layoutIfNeeded()
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
        asyncImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            heightConstraint = make.height.equalTo(150).constraint
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(5)
            make.top.equalTo(asyncImageView.snp.bottom).offset(10)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(5)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
        }
    }
}
