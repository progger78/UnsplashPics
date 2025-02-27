//
//  UserProfile.swift
//  UnsplashPics
//
//  Created by 1 on 26.02.2025.
//

import Foundation

// MARK: - UserProfile
struct UserProfile: Codable {
    let id: String
    let updatedAt: String
    let username: String
    let name: String
    let bio: String?
    let location: String?
    let links: UserLinks?
    let profileImage: ProfileImage?
    let totalCollections: Int
    let totalLikes: Int
    let totalPhotos: Int
    let social: UserSocial?
//    let photos: [UserPhoto]
    let tags: UserTags?
    let followersCount: Int
    let followingCount: Int
    
    var userLocation: String {
        location != nil ? location! : "Локация неизвестна"
    }
    
    // MARK: - ProfileImage
    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
    }

    // MARK: - UserSocial
    struct UserSocial: Codable {
        let instagramUsername: String
        let portfolioUrl: String?
        let twitterUsername: String?
        let paypalEmail: String?
    }

    // MARK: - UserPhoto
    struct UserPhoto: Codable {
        let id: String
        let slug: String
        let createdAt: String
        let updatedAt: String
        let blurHash: String
        let assetType: String
        let urls: PhotoURLs
    }

    // MARK: - PhotoURLs
    struct PhotoURLs: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
    }

    // MARK: - UserTags
    struct UserTags: Codable {
        let custom: [Tag]
        let aggregated: [Tag]
    }

    // MARK: - Tag
    struct Tag: Codable {
        let type: String
        let title: String
    }

    // MARK: - UserLinks
    struct UserLinks: Codable {
        let selfLink: String
        let html: String
        let photos: String
        let likes: String
        let portfolio: String?
        let following: String
        let followers: String

        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case html, photos, likes, portfolio, following, followers
        }
    }
}
