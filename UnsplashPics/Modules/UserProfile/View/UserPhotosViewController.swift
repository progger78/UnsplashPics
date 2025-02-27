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

    weak var delegate: UserPhotosViewControllerDelegate?
    
    let reusableCollectionView = ReusableCollectionView()
    
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
    }
    
    func embedViews() {
        view.addSubview(reusableCollectionView)
    }
    
    func configureConstraints() {
        reusableCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
