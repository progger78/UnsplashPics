//
//  SearchViewController.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

protocol MainSearchViewControllerProtocol: AnyObject {
    func appendInitialPhotos(photos: [UnsplashPhoto])
    func appendNewPhotos(photos: [UnsplashPhoto])
    func setLoading(_ isLoading: Bool)
    func showError(with errorMessage: String)
}

final class MainSearchViewController: UIViewController {
    
    let presenter: MainSearchPresenterProtocol
    let mainView = MainSearchView()
    
    init() {
        let networkService = NetworkServiceImpl()
        self.presenter = MainSearchPresenterImpl(networkService: networkService)
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        mainView.setDelegate(self)
        mainView.delegate = self
        Task { await presenter.fetchInitialPhotos() }
        mainView.configureNavBar(with: navigationItem)
    }
}

private extension MainSearchViewController {
    func initialize() {
        configureView()
        embedViews()
        configureConstraints()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func embedViews() {
        view.addSubview(mainView)
    }
    
    func configureConstraints() {
        mainView.turnOffTAMIC()
        mainView.equalToSuperview(view: view)
    }
}

extension MainSearchViewController: SuggestionTextFieldDelegate {
    var suggestionsHistory: [String] {
        return presenter.suggestionHistory
    }
    
    func didTapFilters() {
        let vc = FiltersViewController()
        vc.delegate = self
        if let controller = vc.sheetPresentationController {
            controller.prefersGrabberVisible = true
            controller.detents = [.medium()]
        }
        present(vc, animated: true)
    }
    
    func didTapSearch(with query: String) {
        Task { await self.presenter.searchPhotos(with: query, filters: nil) }
    }
}

extension MainSearchViewController: MainSearchViewProtocol {
    func didTapCell(in view: UIView, photo: UnsplashPhoto) {
        let vc = DetailInfoViewController(photoId: photo.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMorePhotos() {
        Task { await presenter.fetchMorePhotos() }
    }
}
extension MainSearchViewController: MainSearchViewControllerProtocol {
    func appendInitialPhotos(photos: [UnsplashPhoto]) {
        mainView.update(with: photos)
    }
    
    func appendNewPhotos(photos: [UnsplashPhoto]) {
        mainView.appendPhotos(photos)
    }
    
    func setLoading(_ isLoading: Bool) {
        mainView.isLoading = isLoading
    }
    
    func showError(with errorMessage: String) {
        
    }
}

extension MainSearchViewController: FiltersViewControllerProtocol {
    func didSelectOptions(_ options: [FilterModel.Section : URLQueryItem]) {
        let filters = Array(options.values)
        Task { await presenter.searchPhotos(with: "", filters: filters) }
    }
}
