//
//  UserProfileViewController.swift
//  UnsplashPics
//
//  Created by 1 on 18.02.2025.
//

import UIKit

protocol UserProfileViewControllerProtocol: AnyObject {
    func setNormalState<T: Decodable>(with data: T, for type: UserInfoType)
    func setLoadingState(_ isLoading: Bool, for type: UserInfoType)
    func appendNewData<T: Decodable>(data: T, for type: UserInfoType)
    func setErrorState(with errorMessage: String)
}

class UserProfileViewController: UIViewController {
    
    var presenter: UserProfilePresenterProtocol
    
    var userView = UserProfileView()
    
    var user: UserProfile? {
        didSet { setupData() }
    }
    
    init(username: String) {
        let networkService = NetworkServiceImpl()
        presenter = UserProfilePresenterImpl(networkService: networkService, username: username)
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        Task { await presenter.loadUserProfile() }
    }
    
    func setupData() {
        guard let user else { return }
        
        presenter.user = user
        Task {
            await presenter.loadUserPhotos()
            await presenter.loadUserCollections()
        }
    }
}

private extension UserProfileViewController {
    func initialize() {
        embedViews()
        configureConstraints()
        userView.setDelegate(delegate: self)
        
        addChild(userView.customTabBarVC)
        userView.customTabBarVC.didMove(toParent: self)
    }
    
    func embedViews() {
        view.addSubview(userView)
    }
    
    func configureConstraints() {
        userView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension UserProfileViewController: UserProfileViewControllerProtocol {
    func setNormalState<T>(with data: T, for type: UserInfoType) where T : Decodable {
        switch type {
        case .user:
            guard let user = data as? UserProfile else { return }
            
            self.user = user
            userView.set(state: .normal(user: user))
        case .collections:
            guard let collections = data as? [UserCollection] else { return }
            
            userView.loadInitialCollections(collections)
            
        case .photos:
            guard let photos = data as? [UnsplashPhoto] else { return }
            
            userView.loadInitiaPhotos(photos)
        }
    }
    
    func appendNewData<T: Decodable>(data: T, for type: UserInfoType) {
        switch type {
        case .user:
            break
        case .collections:
            guard let collections = data as? [UserCollection] else { return }
            
            userView.appendNewCollections(collections)
        case .photos:
            guard let photos = data as? [UnsplashPhoto] else { return }
            
            userView.appendNewPhotos(photos)
        }
    }
    
    func setLoadingState(_ isLoading: Bool, for type: UserInfoType) {
        guard type == .user else { return }
        
        userView.set(state: .loading(isLoading: isLoading))
    }

    
    func setErrorState(with errorMessage: String) {
        userView.set(state: .error(errorMessage: errorMessage))
    }
}

extension UserProfileViewController: UserPhotosViewControllerDelegate {
    func loadMorePhotos() {
        Task { await presenter.loadMorePhotos() }
    }
    
    func didTapCell(with photo: UnsplashPhoto) {
        let vc = DetailInfoViewController(photoId: photo.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserProfileViewController: UserCollectionsViewControllerDelegate {
    func loadMoreCollections() {
        Task { await presenter.loadMoreCollections() }
    }
    
    func didTapCell(with collection: UserCollection) {
        let vc = CollectionViewController(collection: collection)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserProfileViewController: UserProfileViewProtocol {
    func didTapReload() {
        Task { await presenter.loadUserProfile() }
    }
}
