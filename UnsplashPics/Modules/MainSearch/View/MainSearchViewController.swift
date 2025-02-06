//
//  SearchViewController.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

protocol MainSearchViewControllerProtocol: AnyObject {
    func didUpdateUI(with photos: [UnsplashPhoto])
    func setLoading(_ isLoading: Bool)
    func showError(with errorMessage: String)
}

final class MainSearchViewController: UIViewController {
    
    let presenter: MainSearchPresenterProtocol!
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
    
    func didTapSearch(with query: String) {
        self.presenter.addToSuggestionsHistory(query)
        Task { await self.presenter.searchPhotos(for: query)}
    }
}

extension MainSearchViewController: MainSearchViewControllerProtocol {
    func didUpdateUI(with photos: [UnsplashPhoto]) {
        mainView.update(with: photos)
    }
    
    func setLoading(_ isLoading: Bool) {
        mainView.loadingIndicator.animate(isLoading: isLoading)
    }
    
    func showError(with errorMessage: String) {
        
    }
}
