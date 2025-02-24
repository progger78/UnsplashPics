//
//  FavoritesViewController.swift
//  UnsplashPics
//
//  Created by 1 on 22.02.2025.
//

import UIKit

protocol FavoritesViewControllerProtocol: AnyObject {
    func setNormalState(with photos: [UnsplashPhoto])
    func setEmptyState()
}

class FavoritesViewController: UIViewController {

    let favoritesView = FavoritesView()
    var presenter: FavoritesViewPresenterProtocol?

    override func viewWillAppear(_ animated: Bool) {
        presenter?.retrieveFavorites()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}


private extension FavoritesViewController {
    func initialize() {
        embedViews()
        configureConstraints()
        favoritesView.setDelegate(delegate: self)
        favoritesView.delegate = self
    }
    
    func embedViews() {
        view.addSubview(favoritesView)
    }
    
    func configureConstraints() {
        favoritesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FavoritesViewController: FavoritesViewControllerProtocol {
    func setNormalState(with photos: [UnsplashPhoto]) {
        favoritesView.set(state: .normal(photos: photos))
    }
    
    func setEmptyState() {
        favoritesView.set(state: .empty)
    }
}

extension FavoritesViewController: ReusableCollectionViewDelegate {
    func fetchMorePhotos() {
        
    }
    
    func didTapCell(with photo: UnsplashPhoto) {
        let detailVC = DetailInfoViewController(photoId: photo.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func didTapSearchButton() {
        let vc = MainSearchViewController()
        vc.title = "Search"
        vc.shouldFocusTextField = true
        let networkService = NetworkServiceImpl()
        let presenter = MainSearchPresenterImpl(networkService: networkService)
        presenter.view = vc
        vc.presenter = presenter
        navigationController?.pushViewController(vc, animated: true)
    }
}
