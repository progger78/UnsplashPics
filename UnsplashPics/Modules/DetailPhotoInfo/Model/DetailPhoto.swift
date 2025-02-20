//
//  DetailPhoto.swift
//  UnsplashPics
//
//  Created by 1 on 17.02.2025.
//

import Foundation

struct DetailPhoto: Codable, Hashable {
    let id: String
    let createdAt, updatedAt: String
    let description, altDescription: String?
    let urls: Urls
    let links: ProductLinks
    let likes: Int
    let location: Location?
//    let currentUserCollections: [JSONAny]
    let user: User
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DetailPhoto, rhs: DetailPhoto) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Location: Codable {
    let city: String?
    let country: String?
    let position: Position?
}

struct Position: Codable {
    let latitude: Double?
    let longitude: Double?
}

// MARK: - ProductLinks
struct ProductLinks: Codable {
    let linksSelf, html, download, downloadLocation: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download, downloadLocation
    }
}

// MARK: - Urls
struct Urls: Codable {
    let full, regular, small: String
}

// MARK: - User
struct User: Codable {
    let id: String
    let updatedAt: String
    let username, name: String?
    let twitterUsername: String?
    let portfolioURL: String?
    let bio, location: String?
    let links: UserLinks
    let profileImage: ProfileImage
    let instagramUsername: String?
    let totalCollections, totalLikes, totalPhotos, totalPromotedPhotos: Int
    let forHire: Bool
    let social: Social
}

// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio, following, followers: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}

// MARK: - Social
struct Social: Codable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
}
