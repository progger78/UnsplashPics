//
//  MainSearchPresenter.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation

protocol MainSearchPresenterProtocol {
    func searchPhotos(for query: String) async
}

final class MainSearchPresenterImpl: MainSearchPresenterProtocol {
    private let networkService: NetworkService
    private weak var view: SearchViewControllerProtocol?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    @MainActor
    func searchPhotos(for query: String) async {
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
