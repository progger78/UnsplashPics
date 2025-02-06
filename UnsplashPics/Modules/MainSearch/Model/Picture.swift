//
//  Picture.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation

struct UnsplashPhoto: Decodable, Hashable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let color: String
    let likes: Int
    let description: String?
    let urls: Urls

    struct Urls: Decodable, Hashable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: UnsplashPhoto, rhs: UnsplashPhoto) -> Bool {
        lhs.id == rhs.id
    }
}

