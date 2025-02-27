//
//  UserProfilePresenter.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import Foundation


protocol UserProfilePresenterProtocol {
    func loadUserPhotos() async
    func loadMorePhotos() async
    func loadUserCollections() async
    func loadMoreCollections() async
    func loadUserProfile() async
    var view: UserProfileViewControllerProtocol? { get set }
    var user: UserProfile? { get set }
}

class UserProfilePresenterImpl: UserProfilePresenterProtocol {
    weak var view: UserProfileViewControllerProtocol?
    let networkService: NetworkService
    let username: String
    var photosPage = 1
    var collectionsPage = 1
    var user: UserProfile?
    var isLoading = false
    var hasMorePhotos = true
    var hasMoreCollections = true
    var userCollections: [UserCollection] = []
    var userPhotos: [UnsplashPhoto] = []
    
    init(networkService: NetworkService, username: String) {
        self.username = username
        self.networkService = networkService
    }
    
    @MainActor
    func loadUserPhotos() async {
        guard let user else { return }
        
        do {
            let photos = try await networkService.fetchUserInfo(for: username,
                                                              infoType: .photos,
                                                              type: [UnsplashPhoto].self,
                                                              page: photosPage)
            
            userPhotos.append(contentsOf: photos)
            hasMorePhotos = userPhotos.count < user.totalPhotos
            
            if photosPage > 1 {
                view?.appendNewData(data: photos, for: .photos)
            } else {
                view?.setNormalState(with: photos, for: .photos)
            }
            photosPage += 1
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch {
            handleError(error: error)
        }
    }
    
    @MainActor
    func loadUserCollections() async {
        guard let user else { return }
        
        do {
            let collections = try await networkService.fetchUserInfo(for: username,
                                                                     infoType: .collections,
                                                                     type: [UserCollection].self,
                                                                     page: collectionsPage)
            
            userCollections.append(contentsOf: collections)
            hasMoreCollections = userCollections.count < user.totalCollections
            
            if collectionsPage > 1 {
                view?.appendNewData(data: collections, for: .collections)
            } else {
                view?.setNormalState(with: collections, for: .collections)
            }
            collectionsPage += 1
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch {
            handleError(error: error)
        }
    }
    
    func loadMorePhotos() async {
        guard hasMorePhotos, !isLoading  else { return }
        
        isLoading = true
        view?.setLoadingState(true, for: .photos)
        
        defer {
            isLoading = false
            view?.setLoadingState(false, for: .photos)
        }
        
        await loadUserPhotos()
    }
    
    func loadMoreCollections() async {
        guard hasMoreCollections, !isLoading  else { return }
        
        isLoading = true
        view?.setLoadingState(true, for: .collections)
        
        defer {
            isLoading = false
            view?.setLoadingState(false, for: .collections)
        }
        
        await loadUserCollections()
    }
    
    @MainActor
    func loadUserProfile() async {
        view?.setLoadingState(true, for: .user)
        
        defer { view?.setLoadingState(false, for: .user) }
        
        do {
            let user = try await networkService.fetchUserInfo(for: username,
                                                              infoType: .user,
                                                              type: UserProfile.self, page: 1)
            view?.setNormalState(with: user, for: .user)
        } catch {
            print(error)
            handleError(error: error)
        }
    }
    
    func handleError(error: Error) {
        if let networkError = error as? NetworkError {
            view?.setErrorState(with: networkError.description)
        } else {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
        }
    }
}
