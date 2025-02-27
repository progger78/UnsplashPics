//
//  CustomButton.swift
//  CryptoInfo
//
//  Created by 1 on 10.12.2024.
//

import UIKit

class CustomButton: UIView {
    
    enum State {
        case normal
        case disabled
    }
    
    enum ButtonType {
        case iconButton
        case iconWithText
    }
    
    enum IconImage: String {
        case infoIcon = "info.circle"
        case checkmark = "checkmark"
        case add = "plus"
        case reload = "arrow.clockwise.circle"
        case search = "magnifyingglass"
        case delete = "minus"
    }
    
    var state: State = .normal {
        didSet {
            setState()
        }
    }
    
    private let type: ButtonType
    private let button = UIButton(type: .system)
    private let icon: IconImage
    private let mainColor: UIColor
    private var title: String?
    var onTap: (() -> Void)?
    
    init(type: ButtonType, title: String? = nil, icon: IconImage, mainColor: UIColor) {
        self.type = type
        self.title = title
        self.icon = icon
        self.mainColor = mainColor
        super.init(frame: .zero)
      
        setupView()
        configureButton(basedOn: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(basedOn type: ButtonType) {
        switch type {
        case .iconButton:
            setupIconButton()
        case .iconWithText:
            setupIconTextButton()
        }
    }
    
    @objc func buttonTapped() {
        onTap?()
    }
    
    func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func setIcon(_ iconImage: IconImage) {
        button.setImage(UIImage(systemName: iconImage.rawValue), for: .normal)
    }
    
    private func setState() {
        switch state {
        case .normal:
            button.isEnabled = true
            button.backgroundColor = mainColor
        case .disabled:
            button.isEnabled = false
            button.backgroundColor = .systemGray
        }
    }
    
    private func setupView() {
        addSubview(button)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func setupIconTextButton() {
        button.backgroundColor = mainColor
        button.setImage(UIImage(systemName: icon.rawValue), for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupIconButton() {
        let icon = UIImage(systemName: icon.rawValue,
                           withConfiguration: UIImage.SymbolConfiguration(pointSize: 24,
                                                                          weight: .medium))
        button.setImage(icon, for: .normal)
        button.tintColor = mainColor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}
