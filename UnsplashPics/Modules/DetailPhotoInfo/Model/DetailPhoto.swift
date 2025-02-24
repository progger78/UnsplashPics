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
