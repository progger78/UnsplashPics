//
//  SearchViewController.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func didUpdateUI(with: [UnsplashPhoto])
}

class MainSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

