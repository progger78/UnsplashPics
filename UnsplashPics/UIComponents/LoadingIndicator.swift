//
//  LoadingIndicator.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//


import UIKit

class LoadingIndicator: UIView {
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(frame: .zero)
        setupIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(isLoading: Bool) {
        isLoading ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    private func setupIndicator() {
        indicator.tintColor = .systemGray
        indicator.hidesWhenStopped = true
        indicator.turnOffTAMIC()
        addSubview(indicator)
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
