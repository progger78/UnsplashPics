//
//  UserProfilePresenter.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import Foundation


protocol UserProfilePresenterProtocol {
    func loadUserPhotos(for username: String) async
    var view: UserProfileViewControllerProtocol? { get set }
}

class UserProfilePresenterImpl: UserProfilePresenterProtocol {
    weak var view: UserProfileViewControllerProtocol?
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadUserPhotos(for username: String) async {
        do {
            guard let photos = try await networkService.fetchUserPhotos(for: username) else { return }
            view?.setNormalState(with: photos)
        } catch let error as NetworkError {
            view?.setErrorState(with: error.description)
        } catch {
            view?.setErrorState(with: NetworkError.unknownError(error: error).description)
        }
    }
}
