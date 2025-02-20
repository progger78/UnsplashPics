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
    
    init(cornerRadius: CGFloat? = nil) {
        self.cornerRadius = cornerRadius
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
