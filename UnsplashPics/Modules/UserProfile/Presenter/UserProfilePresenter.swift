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
}

class UserProfilePresenterImpl: UserProfilePresenterProtocol {
    private let networkService: NetworkService
    private let username: String
    private var photosPage = 1
    private var collectionsPage = 1
    private var user: UserProfile?
    private var isLoading = false
    private var hasMorePhotos = true
    private var hasMoreCollections = true
    private var userCollections: [UserCollection] = []
    private var userPhotos: [UnsplashPhoto] = []
    weak var view: UserProfileViewControllerProtocol?
    
    init(networkService: NetworkService, username: String) {
        self.username = username
        self.networkService = networkService
    }
    
    func loadUserPhotos() async {
        await loadUserData(page: &photosPage,
                           hasMore: &hasMorePhotos,
                           totalItems: user?.totalPhotos ?? 0,
                           userInfoType: .photos,
                           dataArray: &userPhotos)
    }
    
    func loadUserCollections() async {
        await loadUserData(page: &collectionsPage,
                           hasMore: &hasMoreCollections,
                           totalItems: user?.totalCollections ?? 0,
                           userInfoType: .collections,
                           dataArray: &userCollections)
    }
    
    func loadMorePhotos() async {
        await loadMoreData(isLoading: &isLoading,
                           hasMore: hasMorePhotos,
                           userInfoType: .photos,
                           action: loadUserPhotos)
    }
    
    func loadMoreCollections() async {
        await loadMoreData(isLoading: &isLoading,
                           hasMore: hasMoreCollections,
                           userInfoType: .collections,
                           action: loadUserCollections)
    }
    
    @MainActor
    func loadUserProfile() async {
        view?.setLoadingState(true, for: .user)
        
        defer { view?.setLoadingState(false, for: .user) }
        
        do {
            let fetchedUser = try await networkService.fetchUserInfo(for: username,
                                                                     infoType: .user,
                                                                     type: UserProfile.self,
                                                                     page: 1)
            user = fetchedUser
            view?.setNormalState(with: user, for: .user)
            await loadUserPhotos()
            await loadUserCollections()
        } catch {
            handle(error, for: .user)
        }
    }
    
    @MainActor
    private func loadUserData<T: Decodable>(
        page: inout Int,
        hasMore: inout Bool,
        totalItems: Int,
        userInfoType: UserInfoType,
        dataArray: inout [T]
    ) async {
        do {
            let newData = try await networkService.fetchUserInfo(
                for: username,
                infoType: userInfoType,
                type: [T].self,
                page: page)
            
            dataArray.append(contentsOf: newData)
            hasMore = dataArray.count < totalItems
            
            if newData.isEmpty {
                view?.setEmptyState(for: userInfoType)
                return
            }
          
            if page > 1 {
                view?.appendNewData(data: newData, for: userInfoType)
            } else {
                view?.setNormalState(with: newData, for: userInfoType)
            }
            
            page += 1
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch{
            handle(error, for: userInfoType)
        }
    }
    
    private func loadMoreData(isLoading: inout Bool,
                              hasMore: Bool,
                              userInfoType:  UserInfoType,
                              action: @escaping() async -> Void) async  {
        guard hasMore, !isLoading  else { return }
        
        isLoading = true
        view?.setLoadingState(true, for: userInfoType)
        
        defer {
            isLoading = false
            view?.setLoadingState(false, for: userInfoType)
        }
        
        await action()
    }
    
    private func handle(_ error: Error, for userInfoType: UserInfoType) {
        if let networkError = error as? NetworkError {
            view?.setErrorState(with: networkError.description, for: userInfoType)
        } else {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description, for: userInfoType)
        }
    }
}
