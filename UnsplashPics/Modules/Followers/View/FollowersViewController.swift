//
//  FollowersViewController.swift
//  UnsplashPics
//
//  Created by 1 on 03.03.2025.
//

import UIKit

protocol FollowersViewControllerProtocol: AnyObject {
    func setNormalState(users: [UserForPhoto])
    func setLoadingState(_ isLoading: Bool)
    func append(users: [UserForPhoto])
    func setErrorState(with errorMessage: String)
    func setEmptyState()
}

class FollowersViewController: UIViewController {
    
    let tableView = ReusableTableView()
    var presenter: FollowersPresenterProtocol
    
    init(username: String) {
        let networkService = NetworkServiceImpl()
        presenter = FollowersPresenter(networkService: networkService, username: username)
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initialize()
    }
}

extension FollowersViewController: ReusableTableViewDelegate {
    func didTapCell(with user: UserForPhoto) {
        let userProfileVC = UserProfileViewController(username: user.username)
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func loadMoreData() {
        Task { await presenter.loadMoreData() }
    }
}

private extension FollowersViewController {
    func initialize() {
        embedViews()
        configureConstraints()
        tableView.delegate = self
        Task { await presenter.fetchFollowers() }
    }

    func embedViews() {
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FollowersViewController: FollowersViewControllerProtocol {
    func setNormalState(users: [UserForPhoto]) {
        tableView.update(with: users)
    }
    
    func setLoadingState(_ isLoading: Bool) {
        tableView.isLoading = isLoading
    }
    
    func append(users: [UserForPhoto]) {
        tableView.append(users)
    }
    
    func setErrorState(with errorMessage: String) {
        
    }
    
    func setEmptyState() {
        
    }
}
