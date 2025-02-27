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
    func searchPhotos(with searchTerm: String, filters: String?) async
    func fetchMorePhotos() async
    func reloadData() async
    func fetchInitialPhotos() async
    func addToSuggestionsHistory(_ query: String)
}

final class MainSearchPresenterImpl: MainSearchPresenterProtocol {
    private let networkService: NetworkService
    private var page = 1
    private var isLoading = false
    private var hasMore = true
    private var lastSearchTerm = ""
    private var lastSearchFilters: String? = nil
    var suggestionHistory: [String] = []
    weak var view: (any MainSearchViewControllerProtocol)?
   
     
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func addToSuggestionsHistory(_ query: String) {
        if !suggestionHistory.contains(query) {
            suggestionHistory.appendWithLimit(query, limit: 5)
        }
    }
    
    @MainActor
    func searchPhotos(with searchTerm: String, filters: String? = nil) async {
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
            
            view?.setNormalState(with: photos)
            page += 1
        } catch let error as NetworkError {
            view?.setErrorState(with: error.description)
        } catch {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
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
                guard let newPhotos = try await networkService.fetchMorePhotos(page: page) as? [UnsplashPhoto] else { return }
                
                view?.appendNewPhotos(photos: newPhotos)
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
