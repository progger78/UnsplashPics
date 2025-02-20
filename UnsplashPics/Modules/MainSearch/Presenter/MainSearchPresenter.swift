//
//  MainSearchPresenter.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation

protocol MainSearchPresenterProtocol: AnyObject {
    var suggestionHistory: [String] { get set }
    var view: MainSearchViewControllerProtocol? { get set }
    func searchPhotos(with searchTerm: String, filters: [URLQueryItem]?) async
    func fetchMorePhotos() async
    func fetchInitialPhotos() async
    func addToSuggestionsHistory(_ query: String)
}

final class MainSearchPresenterImpl: MainSearchPresenterProtocol {
    private let networkService: NetworkService
    weak var view: (any MainSearchViewControllerProtocol)?
    var suggestionHistory: [String] = []
    var page = 0
    var isLoading = false
    var hasMore = true
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func addToSuggestionsHistory(_ query: String) {
        if !suggestionHistory.contains(query) {
            suggestionHistory.appendWithLimit(query, limit: 5)
        }
    }
    
    @MainActor
    func searchPhotos(with searchTerm: String, filters: [URLQueryItem]? = nil) async {
        resetSearch()
        addToSuggestionsHistory(searchTerm)
        view?.setLoading(true)
        defer { view?.setLoading(false) }
        
        do {
            guard let photos = try await networkService.searchPhotos(for: searchTerm,
                                                                     with: filters,
                                                                     page: page) else { return }
            hasMore = photos.totalPages > page
            
            view?.appendInitialPhotos(photos: photos.results)
        } catch let error as NetworkError {
            view?.showError(with: error.description)
        } catch {
            view?.showError(with: NetworkError.unknownError(error: error).description)
        }
    }
    
    func resetSearch() {
        page = 0
        isLoading = false
        hasMore = false
    }
    
    @MainActor
    func fetchInitialPhotos() async {
        view?.setLoading(true)
        defer { view?.setLoading(false) }
        
        do {
            guard let photos = try await networkService.fetchInitialPhotos(page: page) else { return }
            
            let unsplashPhotos = convert(photos)
           
            view?.appendInitialPhotos(photos: unsplashPhotos)
        } catch let error as NetworkError {
            view?.showError(with: error.description)
        } catch {
            view?.showError(with: NetworkError.unknownError(error: error).description)
        }
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
    
    
    @MainActor
    func fetchMorePhotos() async {
        page += 1
        guard !isLoading, hasMore else { return }
        
        isLoading = true
        view?.setLoading(true)
        
        defer {
            view?.setLoading(false)
            isLoading = false
        }
        
        do {
            let lastRequestType = networkService.lastRequestType
            switch lastRequestType {
            case .search:
                guard let newPhotos = try await networkService.fetchMorePhotos(page: page) as? SearchResponse else { return }
                view?.appendNewPhotos(photos: newPhotos.results)
            case .initialLoad:
                guard let newPhotos = try await networkService.fetchMorePhotos(page: page) as? [DetailPhoto] else { return }
                let unsplashPhotos = convert(newPhotos)
                view?.appendNewPhotos(photos: unsplashPhotos)
            case .none:
                break
            }
        } catch let error as NetworkError {
            view?.showError(with: error.description)
        } catch {
            view?.showError(with: NetworkError.unknownError(error: error).description)
        }
    }
}
