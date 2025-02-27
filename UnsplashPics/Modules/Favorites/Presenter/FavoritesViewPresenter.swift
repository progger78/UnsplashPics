//
//  FavoritesViewPresenter.swift
//  UnsplashPics
//
//  Created by 1 on 22.02.2025.
//

import Foundation


protocol FavoritesViewPresenterProtocol: AnyObject {
    func retrieveFavorites()
    var view: FavoritesViewControllerProtocol? { get set }
}

class FavoritesViewPresenter: FavoritesViewPresenterProtocol {
    weak var view: FavoritesViewControllerProtocol?
    
    private let persistanceManage = PersistanceManager.shared
    
    func retrieveFavorites() {
        let favorites = persistanceManage.retrieveFavorites()
        let unsplashPhotos = convert(favorites)
        
        guard !unsplashPhotos.isEmpty else { view?.setEmptyState(); return }
        
        view?.setNormalState(with: unsplashPhotos)
    }
    
    private func convert(_ photos: [DetailPhoto]) -> [UnsplashPhoto] {
        return photos.compactMap { photo in
            let photoUrl = photo.urls
            let urls = UnsplashPhoto.Urls(raw: photoUrl.regular,
                                          full: photoUrl.full,
                                          regular: photoUrl.regular,
                                          small: photoUrl.small)
            return UnsplashPhoto(id: photo.id, createdAt: photo.createdAt, likes: photo.likes, urls: urls)
        }
    }
}
