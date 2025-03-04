//
//  UserPhotosViewController.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import UIKit

protocol UserPhotosViewControllerDelegate: AnyObject {
    func loadMorePhotos()
    func didTapCell(with photo: UnsplashPhoto)
}

class UserPhotosViewController: UIViewController {

    enum State {
        case error(errorMessage: String)
        case loading(isLoading: Bool)
        case normal(userPhotos: [UnsplashPhoto])
        case empty
    }
    
    weak var delegate: UserPhotosViewControllerDelegate?
    
    let reusableCollectionView = ReusableCollectionView()
    let stateView = StateView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        reusableCollectionView.delegate = self
    }
    
    func update(with photos: [UnsplashPhoto]) {
        reusableCollectionView.update(with: photos)
    }
    
    func append(_ photos: [UnsplashPhoto]) {
        reusableCollectionView.appendPhotos(photos)
    }
    
    func set(state: State) {
        switch state {
        case .error(let errorMessage):
            stateView.configure(for: .error(errorText: errorMessage))
        case .loading(let isLoading):
            stateView.isHidden = true
            reusableCollectionView.isLoading = isLoading
            stateView.configure(for: .loading(isLoading: isLoading))
        case .normal(let collections):
            reusableCollectionView.isHidden = false
            stateView.isHidden = true
            stateView.configure(for: .default)
            update(with: collections)
        case .empty:
            reusableCollectionView.isHidden = true
            stateView.isHidden = false
            stateView.configure(for: .empty(text:"Нет фото"))
        }
    }
}

extension UserPhotosViewController: ReusableCollectionViewDelegate {
    func fetchMorePhotos() {
        delegate?.loadMorePhotos()
    }
    
    func didTapCell(with photo: UnsplashPhoto) {
        delegate?.didTapCell(with: photo)
    }
}

private extension UserPhotosViewController {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        stateView.isHidden = true
    }
    
    func embedViews() {
        view.addSubviews(reusableCollectionView, stateView)
    }
    
    func configureConstraints() {
        reusableCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
