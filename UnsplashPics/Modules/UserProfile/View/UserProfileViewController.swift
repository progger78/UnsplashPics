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
    func setErrorState(with errorMessage: String, for type: UserInfoType)
    func setEmptyState(for type: UserInfoType)
}

class UserProfileViewController: UIViewController {
    
    var presenter: UserProfilePresenterProtocol
    var userView = UserProfileView()
    let username: String
    
    init(username: String) {
        self.username = username
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
    func setEmptyState(for type: UserInfoType) {
        if type == .collections {
            userView.configureCollectionsVC(with: .empty)
        } else if type == .photos {
            userView.configurePhotosVC(with: .empty)
        }
    }
    
    func setNormalState<T>(with data: T, for type: UserInfoType) where T : Decodable {
        switch type {
        case .user:
            guard let user = data as? UserProfile else { return }
            
            userView.set(state: .normal(data: user))
        case .collections:
            guard let collections = data as? [UserCollection] else { return }
            
            userView.configureCollectionsVC(with: .normal(data: collections))
        case .photos:
            guard let photos = data as? [UnsplashPhoto] else { return }
            
            userView.configurePhotosVC(with: .normal(data: photos))
        case .followers, .following: break
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
        case .followers, .following: break
        }
    }
    
    func setLoadingState(_ isLoading: Bool, for type: UserInfoType) {
        switch type {
        case .user:
            userView.set(state: .loading(isLoading: isLoading))
        case .collections:
            userView.configureCollectionsVC(with: .loading(isLoading: isLoading))
        case .photos:
            userView.configurePhotosVC(with: .loading(isLoading: isLoading))
        case .followers, .following: break
        }
    }

    
    func setErrorState(with errorMessage: String, for type: UserInfoType) {
        switch type {
        case .user:
            userView.set(state: .error(errorMessage: errorMessage))
        case .collections:
            userView.configureCollectionsVC(with: .error(errorMessage: errorMessage))
        case .photos:
            userView.configurePhotosVC(with: .error(errorMessage: errorMessage))
        case .followers, .following: break
        }
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
        let vc = CollectionViewController(collectionId: collection.id)
        vc.title = collection.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserProfileViewController: UserProfileViewProtocol {
    func didTapReload() {
        Task { await presenter.loadUserProfile() }
    }
    
    func didTapFollowers() {
        let vc = FollowersViewController(username: username)
        vc.title = "Подписчики"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapFollowing() {
        let vc = FollowersViewController(username: username)
        vc.title = "Подписки"
        navigationController?.pushViewController(vc, animated: true)
    }
}
