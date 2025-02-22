//
//  SearchViewController.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

protocol MainSearchViewControllerProtocol: AnyObject {
    func appendNewPhotos(photos: [UnsplashPhoto])
    func setLoadingState (_ isLoading: Bool)
    func setErrorState(with errorMessage: String)
    func setEmptyState()
    func setNormalState(with photos: [UnsplashPhoto])
}

final class MainSearchViewController: UIViewController {
    
    
    let mainView = MainSearchView()
    var presenter: MainSearchPresenterProtocol?
    var shouldFocusTextField: Bool? {
        didSet {
            mainView.focusTextFild()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        mainView.setDelegate(self)
        mainView.delegate = self
        Task { await presenter?.fetchInitialPhotos() }
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
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainSearchViewController: SuggestionTextFieldDelegate {
    var suggestionsHistory: [String] {
        guard let suggestionHistory = presenter?.suggestionHistory else { return [] }
        
        return suggestionHistory
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
        Task { await self.presenter?.searchPhotos(with: query, filters: nil) }
    }
}

extension MainSearchViewController: MainSearchViewProtocol {
    func didTapCell(in view: UIView, photo: UnsplashPhoto) {
        let vc = DetailInfoViewController(photoId: photo.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadMorePhotos() {
        Task { await presenter?.fetchMorePhotos() }
    }
    
    func reloadData() {
        Task { await presenter?.reloadData() }
    }
}
extension MainSearchViewController: MainSearchViewControllerProtocol {
    func setLoadingState(_ isLoading: Bool) {
        mainView.set(state: .loading(isLoading: isLoading))
    }
    
    func setErrorState(with errorMessage: String) {
        mainView.set(state: .error(errorMessage: errorMessage))
    }
    
    func setEmptyState() {
        mainView.set(state: .empty)
    }
    
    func setNormalState(with photos: [UnsplashPhoto]) {
        mainView.set(state: .normal(photos: photos))
    }
    
    func appendNewPhotos(photos: [UnsplashPhoto]) {
        mainView.appendPhotos(photos: photos)
    }
}

extension MainSearchViewController: FiltersViewControllerProtocol {
    func didSelectOptions(_ options: [FilterModel.Section : URLQueryItem]) {
        let filters = Array(options.values)
        Task { await presenter?.searchPhotos(with: "", filters: filters) }
    }
}
