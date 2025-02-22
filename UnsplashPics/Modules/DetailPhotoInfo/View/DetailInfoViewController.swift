//
//  DetailInfoViewController.swift
//  UnsplashPics
//
//  Created by 1 on 07.02.2025.
//

import UIKit

protocol DetailInfoControllerProtocol: AnyObject {
    func setLoadingState(_ isLoading: Bool)
    func setErrorState(with errorMessage: String)
    func setNormalState(with photo: DetailPhoto)
}

class DetailInfoViewController: UIViewController {
    
    var presenter: DetailInfoPresenterProtocol
    let detailView = DetailInfoView()
    
    init(photoId: String) {
        let networkService = NetworkServiceImpl()
        self.presenter = DetailInfoPresenterImp(networkService: networkService, photoId: photoId)
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.checkFavStatus()
        detailView.isFavorite = presenter.isFavorite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        initialize()
        Task { await presenter.loadDetailPhotoInfo() }
        detailView.delegate = self
    }
}

extension DetailInfoViewController: DetailInfoControllerProtocol {
    func setLoadingState(_ isLoading: Bool) {
        detailView.set(state: .loading(isLoading: isLoading))
    }
    
    func setErrorState(with errorMessage: String) {
        detailView.set(state: .error(errorMessage: errorMessage))
    }
    
    func setNormalState(with photo: DetailPhoto) {
        detailView.set(state: .normal(photo: photo))
    }
}

extension DetailInfoViewController: DetailInfoViewDelegate {
    func didTapContainer(with user: User) {
        let vc = UserProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapFavoriteButton(for photo: DetailPhoto) {
        if presenter.isFavorite {
            presenter.deleteFromFavorites(photo: photo)
        } else {
            presenter.addToFavorites(photo: photo)
        }
        detailView.isFavorite = presenter.isFavorite
        detailView.updateFavoriteButtonTitle()
    }
    
    func showSnackbar(message: String) {
        presentSnackBar(message: message, in: view, type: .success)
    }
    
    func didTapShare(_ photo: DetailPhoto) {
        Task {
            if let image = await ImageLoader.shared.fetchImage(for: photo.urls.full) {
                let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                present(activityController, animated: true)
            } else {
                print("Failed to send")
            }
        }
    }
    
    func reloadData() {
        Task { await presenter.loadDetailPhotoInfo() }
    }
}

private extension DetailInfoViewController {
    func initialize() {
        embedViews()
        configureConstraints()
        detailView.configureView(with: navigationItem)
    }
    
    func embedViews() {
        view.addSubview(detailView)
    }
    
    func configureConstraints() {
        detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
