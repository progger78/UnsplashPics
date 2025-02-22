//
//  StateView.swift
//  UnsplashPics
//
//  Created by 1 on 21.02.2025.
//

import UIKit

class StateView: UIView {
    
    enum State {
        case error(errorText: String)
        case empty(text: String)
        case loading(isLoading: Bool)
        case `default`
    }
    
    private let messageLabel = CustomLabel(type: .custom(font: .systemFont(ofSize: 24, weight: .semibold),
                                                         textColor: .secondaryLabel,
                                                         alignment: .center),
                                           numberOfLines: 3)
    private let iconImageView = UIImageView()
    private let loadingIndicator = LoadingIndicator()
    private let reloadButton = CustomButton(type: .iconWithText,
                                            title: "Перезагрузить",
                                            icon: .reload,
                                            mainColor: .systemPink)
    private let actionButton = CustomButton(type: .iconWithText,
                                            title: "Найти фото",
                                            icon: .search,
                                            mainColor: .systemPink)
    
    var onReloadTap: (() -> Void)?
    var onActionButtonTap: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubviews(messageLabel, iconImageView, loadingIndicator, reloadButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for state: State) {
        switch state {
        case .error(let errorText):
            reloadButton.onTap = onReloadTap
            backgroundColor = .systemBackground
            DispatchQueue.main.async {
                self.iconImageView.isHidden = false
                self.messageLabel.isHidden = false
                self.reloadButton.isHidden = false
                self.iconImageView.image = UIImage(systemName: "exclamationmark.triangle")
                self.iconImageView.tintColor = .systemRed
                self.messageLabel.set(errorText)
            }
        case .empty(let text):
            DispatchQueue.main.async {
                self.iconImageView.isHidden = false
                self.messageLabel.isHidden = false
                self.reloadButton.isHidden = true
                self.iconImageView.image = UIImage(systemName: "magnifyingglass")
                self.iconImageView.tintColor = .systemGray4
                self.messageLabel.set(text)
                self.setupActionButton()
            }
        case .loading(let isLoading):
            iconImageView.isHidden = true
            messageLabel.isHidden = true
            reloadButton.isHidden = true
            bringSubviewToFront(loadingIndicator)
            loadingIndicator.animate(isLoading: isLoading)
        case .default:
            iconImageView.isHidden = true
            messageLabel.isHidden = true
            reloadButton.isHidden = true
            loadingIndicator.animate(isLoading: false)
            actionButton.isHidden = true
        }
    }
    
    func setupActionButton() {
        guard onActionButtonTap != nil else { return }
        
        addSubview(actionButton)
        actionButton.isHidden = false
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        actionButton.onTap = onActionButtonTap
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
            make.size.equalTo(100)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
    }
}
