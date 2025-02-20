//
//  CustomMenu.swift
//  UnsplashPics
//
//  Created by 1 on 20.02.2025.
//

import UIKit

final class CustomMenu {
    var onShareTap: (() -> Void)?
    var onDowloadToGalleryTap: (() -> Void)?
    var onOrderChangeTap: (() -> Void)?

    func createMenu() -> UIMenu {
        var actions: [UIAction] =  []
        
        if let onShareTap {
            let action = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                onShareTap()
            }
            actions.append(action)
        }
        
        if let onDowloadToGalleryTap  {
            let action = UIAction(title: "Сохранить", image: UIImage(systemName: "square.and.arrow.down")) { _ in
                onDowloadToGalleryTap()
            }
            actions.append(action)
        }
        
        if let onOrderChangeTap {
            let action = UIAction(title: "Режим отображения", image: UIImage(systemName: "arrow.2.squarepath")) { _ in
                onOrderChangeTap()
            }
            actions.append(action)
        }
        
        let menu = UIMenu(children: actions)
        return menu
    }
}
