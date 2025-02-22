//
//  DetailInfoPresenter.swift
//  UnsplashPics
//
//  Created by 1 on 17.02.2025.
//

import Foundation


protocol DetailInfoPresenterProtocol { 
    func loadDetailPhotoInfo() async
    func addToFavorites(photo: DetailPhoto)
    func deleteFromFavorites(photo: DetailPhoto)
    func checkFavStatus()
    var photoId: String { get set }
    var view: DetailInfoControllerProtocol? { get set }
    var isFavorite: Bool { get set }
}

class DetailInfoPresenterImp: DetailInfoPresenterProtocol {
    weak var view: (any DetailInfoControllerProtocol)?
    var networkService: NetworkService
    var photoId: String
    var isFavorite = false
    
    init(networkService: NetworkService, photoId: String) {
        self.networkService = networkService
        self.photoId = photoId
    }
    
    func checkFavStatus() {
        let favorites = PersistanceManager.shared.retrieveFavorites()
        isFavorite = favorites.contains(where: { $0.id == photoId })
    }
    
    @MainActor
    func loadDetailPhotoInfo() async {
        view?.setLoadingState(true)
        
        defer { view?.setLoadingState(false) }
        
        do {
            guard let detailPhoto = try await networkService.loadDetailPhoto(for: photoId) else { return }
            
            view?.setNormalState(with: detailPhoto)
        } catch let error as NetworkError {
            view?.setErrorState(with: error.description)
        } catch {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
        }
    }
    
    func addToFavorites(photo: DetailPhoto) {
        do {
            try PersistanceManager.shared.updateWith(favorite: photo, actionType: .add)
            isFavorite = true
        } catch {
            print(error)
        }
    }
    
    func deleteFromFavorites(photo: DetailPhoto) {
        do {
            try PersistanceManager.shared.updateWith(favorite: photo, actionType: .remove)
            isFavorite = false
        } catch {
            print(error)
        }
    }
}
