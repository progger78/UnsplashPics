//
//  UserProfileViewController.swift
//  UnsplashPics
//
//  Created by 1 on 18.02.2025.
//

import UIKit

class UserProfileViewController: UIViewController {

    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
