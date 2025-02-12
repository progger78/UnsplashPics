//
//  DetailInfoViewController.swift
//  UnsplashPics
//
//  Created by 1 on 07.02.2025.
//

import UIKit


class DetailInfoViewController: UIViewController {
    
    let photo: UnsplashPhoto
    
    init(photo: UnsplashPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
    }
}
