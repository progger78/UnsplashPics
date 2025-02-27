//
//  UserCollection.swift
//  UnsplashPics
//
//  Created by 1 on 24.02.2025.
//

import Foundation

struct UserCollection: Codable {
    let id: String
    let title: String
    let description: String?
    let publishedAt: String
    let lastCollectedAt: String
    let updatedAt: String
    let featured: Bool
    let totalPhotos: Int
    let isPrivate: Bool
    let shareKey: String?
    let links: CollectionLinks
    let coverPhoto: CoverPhoto
    
    var lastUpdated: String?  {
        guard let dateString = Date.format(dateString: updatedAt) else { return nil }
        
        return dateString
    }
    
    enum CodingKeys: String, CodingKey {
            case id, title, description, publishedAt, lastCollectedAt, updatedAt, featured, totalPhotos, shareKey, 
                 links, coverPhoto
            case isPrivate = "private"
        }
    
    struct CoverPhoto: Codable {
        let id: String
        let urls: PhotoURLs
    }

    struct PhotoURLs: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    struct CollectionLinks: Codable {
        let selfLink: String
        let html: String
        let photos: String
        let related: String

        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
            case html, photos, related
        }
    }
}
