//
//  CollectionViewController.swift
//  UnsplashPics
//
//  Created by 1 on 25.02.2025.
//

import UIKit

protocol CollectionViewControllerProtocol: AnyObject  {
    func appendNewPhotos(photos: [UnsplashPhoto])
    func setLoadingState (_ isLoading: Bool)
    func setErrorState(with errorMessage: String)
    func setNormalState(with photos: [UnsplashPhoto])
}

class CollectionViewController: UIViewController {

    let reusableCollectionView = ReusableCollectionView()
    let collection: UserCollection
    var presenter: CollectionViewPresenterProtocol
    
    init(collection: UserCollection) { 
        self.collection = collection
        let networkSerivce = NetworkServiceImpl()
        presenter = CollectionViewPresenterImpl(networkService: networkSerivce)
        presenter.collection = collection
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reusableCollectionView.delegate = self
        initialize()
        Task { await presenter.loadCollectionPhotos() }
    }
}

private extension CollectionViewController {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
        
    }
    
    func configureView() {
        title  = collection.title
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

extension CollectionViewController: ReusableCollectionViewDelegate {
    func didTapCell(with photo: UnsplashPhoto) {
        let vc = DetailInfoViewController(photoId: photo.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchMorePhotos() {
        Task { await presenter.loadMoreCollectionPhotos() }
    }
}

extension CollectionViewController: CollectionViewControllerProtocol {
    func appendNewPhotos(photos: [UnsplashPhoto]) {
        reusableCollectionView.appendPhotos(photos)
    }
    
    func setLoadingState(_ isLoading: Bool) {
        
    }
    
    func setErrorState(with errorMessage: String) {
        
    }
    
    func setNormalState(with photos: [UnsplashPhoto]) {
        reusableCollectionView.update(with: photos)
    }
}
