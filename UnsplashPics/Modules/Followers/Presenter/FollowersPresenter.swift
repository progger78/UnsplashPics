//
//  FollowersPresenter.swift
//  UnsplashPics
//
//  Created by 1 on 03.03.2025.
//

import Foundation

protocol FollowersPresenterProtocol {
    func fetchFollowers() async
    func loadMoreData() async
    var view: FollowersViewControllerProtocol? { get set }
}

class FollowersPresenter: FollowersPresenterProtocol {
    let networkService: NetworkService
    var view: FollowersViewControllerProtocol?
    var page = 1
    var username: String
    var hasMorePhotos = true
    var isLoading = false
    
    init(networkService: NetworkService, username: String) {
        self.networkService = networkService
        self.username = username
    }
    
    @MainActor
    func fetchFollowers() async {
        do {
            let followers = try await networkService.fetchUserInfo(for: username,
                                                                   infoType: .followers,
                                                                   type: [UserForPhoto].self,
                                                                   page: page)
            if followers.isEmpty {
                view?.setEmptyState()
                return
            }
            
            if page > 1 {
                view?.append(users: followers)
            } else {
                view?.setNormalState(users: followers)
            }
            page += 1
        } catch {
            handle(error)
        }
    }
    
    func loadMoreData() async {
        print("Loading")
        guard hasMorePhotos, !isLoading  else { return }
        print("Loading")
        isLoading = true
        view?.setLoadingState(true)
        
        defer {
            isLoading = false
            view?.setLoadingState(false)
        }
        
        await fetchFollowers()
        try? await Task.sleep(nanoseconds: 300_000_000)
    }
    
    private func handle(_ error: Error) {
        if let networkError = error as? NetworkError {
            view?.setErrorState(with: networkError.description)
        } else {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
        }
    }
}
