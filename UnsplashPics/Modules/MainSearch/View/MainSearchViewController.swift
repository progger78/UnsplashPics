//
//  SearchViewController.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

protocol MainSearchViewControllerProtocol: AnyObject {
    func didUpdateUI(with photos: [UnsplashPhoto])
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
        Task { await presenter.searchPhotos(for: "Blue")}
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
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.equalToSuperview(view: view)
    }
}

extension MainSearchViewController: MainSearchViewControllerProtocol {
    func didUpdateUI(with photos: [UnsplashPhoto]) {
        mainView.update(with: photos)
    }
    
    func showError(with errorMessage: String) {
        
    }
}
