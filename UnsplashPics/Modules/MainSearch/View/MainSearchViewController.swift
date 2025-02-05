//
//  SearchViewController.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func didUpdateUI(with: [UnsplashPhoto])
    func showError(with errorMessage: String)
}

class MainSearchViewController: UIViewController {

    let presenter: MainSearchPresenterProtocol!
    
    init() {
        let networkService = NetworkServiceImpl()
        self.presenter = MainSearchPresenterImpl(networkService: networkService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        Task { await presenter.searchPhotos(for: "Blue")}
    }
}

