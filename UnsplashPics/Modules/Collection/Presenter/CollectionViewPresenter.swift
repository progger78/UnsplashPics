//
//  CollectionViewPresenter.swift
//  UnsplashPics
//
//  Created by 1 on 25.02.2025.
//

import Foundation


protocol CollectionViewPresenterProtocol  {
    func loadCollectionPhotos() async
    func loadMoreCollectionPhotos() async
    var view: CollectionViewControllerProtocol? { get set }
    var collection: UserCollection? { get set }
   
}
class CollectionViewPresenterImpl: CollectionViewPresenterProtocol {
    weak var view: (any CollectionViewControllerProtocol)?
    let networkService: NetworkService
    var collection: UserCollection?
    var page: Int = 1
    var collectionPhotos: [UnsplashPhoto] = []
    var isLoading = false
    var hasMore = true
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    @MainActor
    func loadCollectionPhotos() async {
        guard let collection else { return }
        
        isLoading = true
        view?.setLoadingState(true)
        
        defer {
            isLoading = false
            view?.setLoadingState(false)
        }
        
        do {
            let collectionPhotos: [DetailPhoto] = try await networkService.fetchCollectionPhotos(for: collection.id, page: page)
            let converted = convert(collectionPhotos)
            let newUniquePhotos = converted.filter { newPhoto in
                !self.collectionPhotos.contains { existingPhoto in existingPhoto.id == newPhoto.id }
            }
            self.collectionPhotos.append(contentsOf: newUniquePhotos)
            hasMore = !newUniquePhotos.isEmpty && collectionPhotos.count == 30
            
            if page > 1 {
                view?.appendNewPhotos(photos: newUniquePhotos)
            } else {
                view?.setNormalState(with: newUniquePhotos)
            }
            
            page += 1
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch let error as NetworkError {
            view?.setErrorState(with: error.description)
        } catch {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
        }
    }


    func loadMoreCollectionPhotos() async {
        guard !isLoading, hasMore else { return }
        
        isLoading = true
        view?.setLoadingState(true)
        
        defer {
            isLoading = false
            view?.setLoadingState(false)
        }
        
        await loadCollectionPhotos()
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
