//
//  AsyncImageView.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit

class AsyncImageView: UIView {

    private let imageView = UIImageView()
    private let imageLoader = ImageLoader.shared
    var cornerRadius: CGFloat?
    var hasBorderColor: Bool
    
    init(cornerRadius: CGFloat? = nil, hasBorderColor: Bool = false) {
        self.cornerRadius = cornerRadius
        self.hasBorderColor = hasBorderColor
        super.init(frame: .zero)
        setupImage()
    }
    
    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImage() {
        addSubview(imageView)
        imageView.layer.cornerRadius = cornerRadius ?? 0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        if hasBorderColor {
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.systemPink.cgColor
        }
    }
    
    @MainActor
    func setImage(for urlString: String?) async {
        guard let urlString else {
            imageView.image = UIImage(systemName: "photo.circle")
            return
        }
        imageView.image = await imageLoader.fetchImage(for: urlString)
    }
}
