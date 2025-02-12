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
    func searchPhotos(for query: String) async
    func addToSuggestionsHistory(_ query: String)
}

final class MainSearchPresenterImpl: MainSearchPresenterProtocol {
    private let networkService: NetworkService
    weak var view: (any MainSearchViewControllerProtocol)?
    var suggestionHistory: [String] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func addToSuggestionsHistory(_ query: String) {
        if !suggestionHistory.contains(query) {
            suggestionHistory.appendWithLimit(query, limit: 5)
        }
    }
    
    @MainActor
    func searchPhotos(for query: String) async {
        guard query != suggestionHistory.last else  { return }
        
        addToSuggestionsHistory(query)
        view?.setLoading(true)
        defer { view?.setLoading(false) }
        
        do {
            guard let photos = try await networkService.searchPhotos(for: query, page: 1) else { return }
            view?.didUpdateUI(with: photos.results)
        } catch let error as NetworkError {
            view?.showError(with: error.description)
        } catch {
            view?.showError(with: NetworkError.unknownError(error: error).description)
        }
    }
}
