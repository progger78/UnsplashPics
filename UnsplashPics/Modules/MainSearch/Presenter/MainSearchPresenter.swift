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
    func reloadData() async
    func fetchInitialPhotos() async
    func addToSuggestionsHistory(_ query: String)
}

final class MainSearchPresenterImpl: MainSearchPresenterProtocol {
    private let networkService: NetworkService
    weak var view: (any MainSearchViewControllerProtocol)?
    var suggestionHistory: [String] = []
    var page = 1
    var isLoading = false
    var hasMore = true
    var lastSearchTerm = ""
    var lastSearchFilters: [URLQueryItem]? = nil
     
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
        lastSearchTerm = searchTerm
        lastSearchFilters = filters
        resetSearch()
        addToSuggestionsHistory(searchTerm)
        view?.setLoadingState(true)
        defer { view?.setLoadingState(false) }
        
        do {
            guard let photos = try await networkService.searchPhotos(for: searchTerm,
                                                                     with: filters,
                       
                                                                     page: page)
            else { return }
            
            hasMore = photos.totalPages > page
            
            if photos.results.isEmpty {
                view?.setEmptyState()
                return
            }
            
            view?.setNormalState(with: photos.results)
            page += 1
        } catch let error as NetworkError {
            view?.setErrorState(with: error.description)
        } catch {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
        }
    }
    
    func reloadData() async {
        await searchPhotos(with: lastSearchTerm, filters: lastSearchFilters)
    }
    
    func resetSearch() {
        page = 1
        isLoading = false
        hasMore = false
    }
    
    @MainActor
    func fetchInitialPhotos() async {
        view?.setLoadingState(true)
        defer { view?.setLoadingState(false) }
        
        do {
            guard let photos = try await networkService.fetchInitialPhotos(page: page) else { return }
            
            let unsplashPhotos = convert(photos)
            
            view?.setNormalState(with: unsplashPhotos)
            page += 1
        } catch let error as NetworkError {
            view?.setErrorState(with: error.description)
        } catch {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
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
        guard !isLoading, hasMore else { return }
        
        isLoading = true
        view?.setLoadingState(true)
        
        defer {
            view?.setLoadingState(false)
            isLoading = false
        }
        
        do {
            let lastRequestType = networkService.lastRequestType
            switch lastRequestType {
            case .search:
                guard let newPhotos = try await networkService.fetchMorePhotos(page: page) as? SearchResponse else { return }
                hasMore = newPhotos.totalPages > page
                view?.appendNewPhotos(photos: newPhotos.results)
            case .initialLoad:
                guard let newPhotos = try await networkService.fetchMorePhotos(page: page) as? [DetailPhoto] else { return }
                
                let unsplashPhotos = convert(newPhotos)
                view?.appendNewPhotos(photos: unsplashPhotos)
            case .none:
                break
            }
            page += 1
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch let error as NetworkError {
            view?.setErrorState(with: error.description)
        } catch {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
        }
    }
}
