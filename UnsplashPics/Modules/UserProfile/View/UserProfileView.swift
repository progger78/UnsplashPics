//
//  UserProfileView.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import UIKit

protocol UserProfileViewProtocol: AnyObject {
    func didTapReload()
}
class UserProfileView: UIView {
    
    weak var delegate: UserProfileViewProtocol?
    
    enum State {
        case error(errorMessage: String)
        case loading(isLoading: Bool)
        case normal(user: UserProfile)
    }
    
    let profileImageView = AsyncImageView(cornerRadius: 70, hasBorderColor: true)
    let nameLabel = CustomLabel(type: .subtitle, numberOfLines: 1)
    let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.tintColor = .systemPink
        return imageView
    }()
    let locationLabel = CustomLabel(type: .secondary, numberOfLines: 1)
    let customStackView = CustomStackView()
    lazy var customTabBarVC: TabsPageViewController = {
        let tabVC = TabsPageViewController()
        tabVC.firstTabVC = userPhotosVC
        tabVC.secondTabVC = userCollectionsVC
        return tabVC
    }()
    
    private let userPhotosVC = UserPhotosViewController()
    private let userCollectionsVC = UserCollectionsViewController()
    private let stateView = StateView()
    
    init() {
        super.init(frame: .zero)
        initialize()
        stateView.onReloadTap = { self.delegate?.didTapReload() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: UserProfile) {
        Task { await profileImageView.setImage(for: user.profileImage?.large ) }
        customStackView.set(with: user)
        nameLabel.set(user.name)
        locationLabel.set(user.userLocation)
        let totalPhotosTitle = "Фото(\(user.totalPhotos.formatNumber()))"
        let totalCollectionsTitle = "Коллекции(\(user.totalCollections.formatNumber()))"
        customTabBarVC.updateTitles(firstTab: totalPhotosTitle , secondTab: totalCollectionsTitle)
    }
    
    func set(state: State) {
        switch state {
        case .error(let errorMessage):
            iconImageView.isHidden = true
            profileImageView.isHidden = true
            bringSubviewToFront(stateView)
            stateView.configure(for: .error(errorText: errorMessage))
        case .loading(let isLoading):
            if isLoading {
                iconImageView.isHidden = true
                profileImageView.isHidden = true
            }
            stateView.configure(for: .loading(isLoading: isLoading))
        case .normal(let user):
            iconImageView.isHidden = false
            profileImageView.isHidden = false
            stateView.isHidden = true
            stateView.configure(for: .default)
            configure(with: user)
        }
    }
    
    func setDelegate(delegate: UserProfileViewController) {
        userPhotosVC.delegate = delegate
        userCollectionsVC.delegate = delegate
        self.delegate = delegate
    }
    
    func loadInitiaPhotos(_ photos: [UnsplashPhoto]) {
        userPhotosVC.update(with: photos)
    }
    
    func appendNewPhotos(_ photos: [UnsplashPhoto]) {
        userPhotosVC.append(photos)
    }
    
    func loadInitialCollections(_ collections: [UserCollection]) {
        userCollectionsVC.update(with: collections)
    }
    
    func appendNewCollections(_ collections: [UserCollection]) {
        userCollectionsVC.append(collections)
    }
}

private extension UserProfileView {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        backgroundColor = .systemBackground
    }
    
    func embedViews() {
        addSubviews(stateView,
                    profileImageView,
                    nameLabel,
                    iconImageView,
                    locationLabel,
                    customStackView,
                    customTabBarVC.view)
    }
    
    func configureConstraints() {
        stateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalTo(locationLabel.snp.leading).offset(-5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        customStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
        }
        
        customTabBarVC.view.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(customStackView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
}
