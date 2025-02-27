//
//  MainTabBarController.swift
//  UnsplashPics
//
//  Created by 1 on 04.12.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .systemPink
        UITabBar.appearance().backgroundColor = .systemBackground
        viewControllers = [createSearchNC(), createFavoritesNC()]
    }
    
    private func createSearchNC() -> UINavigationController {
        let searchVC = MainSearchViewController()
        let searchPresenter = MainSearchPresenterImpl(networkService: service)
        searchVC.presenter = searchPresenter
        searchPresenter.view = searchVC
        searchVC.title = "Photos"
        searchVC.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(systemName: "camera.aperture"), tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func createFavoritesNC() -> UINavigationController {
        let favoritesVC = FavoritesViewController()
        let favoritesPresenter = FavoritesViewPresenter()
        favoritesVC.presenter = favoritesPresenter
        favoritesPresenter.view = favoritesVC
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoritesVC)
    }
    
//    private func createSettingsNC() -> UINavigationController {
//        let settingsVC = SettingsViewController()
//        settingsVC.title = "Settings"
//        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 2)
//        return UINavigationController(rootViewController: settingsVC)
//    }
}
