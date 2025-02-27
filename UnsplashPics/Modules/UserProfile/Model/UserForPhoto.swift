//
//  User.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import Foundation

// MARK: - User
struct UserForPhoto: Codable {
    let id: String
    let username, name: String
    let location: String?
    let profileImage: ProfileImage
    let totalPhotos: Int
    
    var userLocation: String {
        location != nil ? location! : "Локация неизвестна"
    }

    // MARK: - ProfileImage
    struct ProfileImage: Codable {
        let small, medium, large: String
    }
}

