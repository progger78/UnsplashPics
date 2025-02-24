//
//  UserProfileViewController.swift
//  UnsplashPics
//
//  Created by 1 on 18.02.2025.
//

import UIKit

protocol UserProfileViewControllerProtocol: AnyObject {
    func setNormalState(with photos: [DetailPhoto])
    func setErrorState(with errorMessage: String)
}

class UserProfileViewController: UIViewController {

    let user: User
    var presenter: UserProfilePresenterProtocol
    
    let userView = UserProfileView()
    
    init(user: User) {
        self.user = user
        let networkService = NetworkServiceImpl()
        presenter = UserProfilePresenterImpl(networkService: networkService)
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        Task { await presenter.loadUserPhotos(for: user.username) }
        userView.configure(with: user)
    }
}

private extension UserProfileViewController {
    func initialize() {
        embedViews()
        configureConstraints()
    }
    
    func embedViews() {
        view.addSubview(userView)
    }
    
    func configureConstraints() {
        userView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

extension UserProfileViewController: UserProfileViewControllerProtocol{
    func setNormalState(with photos: [DetailPhoto]) {
        print(photos.count)
    }
    
    func setErrorState(with errorMessage: String) {
        print(errorMessage)
    }
}
