//
//  CustomSnackBar.swift
//  CryptoInfo
//
//  Created by 1 on 07.12.2024.
//

import UIKit

class CustomSnackBar: UIView {
    
    enum SnackBarType {
        case success
        case failure
    }
    
    private let messageLabel = UILabel()
    private let actionButton = UIButton()
    private let iconImageView = UIImageView()
    private var actionHandler: (() -> Void)?
    private var type: SnackBarType?
    
    init(message: String,
         actionTitle: String?,
         type: SnackBarType?,
         actionHandler: (() -> Void)? = nil) {
        super.init(frame: .zero)
        setupUI(message: message, actionTitle: actionTitle,  type: type, actionHandler: actionHandler)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(message: String, 
                         actionTitle: String?,
                         type: SnackBarType?,
                         actionHandler: (() -> Void)?) {
        backgroundColor = .systemPink
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        
        if let type {
            iconImageView.tintColor = .white
            switch type {
            case .success:
                iconImageView.image = UIImage(systemName: "checkmark.seal.fill")
            case .failure:
                iconImageView.image = UIImage(systemName: "multiply")
            }
        }
       
        if let actionTitle {
            actionButton.setTitle(actionTitle, for: .normal)
            actionButton.setTitleColor(.label, for: .normal)
            actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        } else {
            actionButton.isHidden = true
        }
        
        addSubviews(iconImageView, messageLabel, actionButton)
        
        messageLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
        }
      
        actionButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(16)
            make.size.equalTo(30)
            make.centerY.equalTo(messageLabel.snp.centerY)
        }
        
        self.actionHandler = actionHandler
    }
    
 
    
    @objc private func actionButtonTapped() {
        actionHandler?()
        dismiss()
    }
    
    func show(in parentView: UIView, duration: TimeInterval = 2.0) {
        parentView.addSubview(self)
        
        snp.makeConstraints { make in
            make.horizontalEdges.equalTo(parentView.snp.horizontalEdges).inset(16)
            make.bottom.equalTo(parentView.safeAreaLayoutGuide).offset(-15)
        }
        
        self.transform = CGAffineTransform(translationX: 0, y: 100)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.transform = .identity
            self.alpha = 1
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.dismiss()
        }
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 100)
            self.alpha = 0
        }) { _ in
            self.actionHandler?()
            self.removeFromSuperview()
         
        }
    }
}
