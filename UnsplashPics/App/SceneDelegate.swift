//
//  SceneDelegate.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupTheme()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: MainSearchViewController())
        window?.makeKeyAndVisible()
    }
    
    func setupTheme() {
        UINavigationBar.appearance().tintColor = .systemPink
    }
}

