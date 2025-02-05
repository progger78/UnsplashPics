//
//  SearchResponse.swift
//  UnsplashPics
//
//  Created by 1 on 05.02.2025.
//

import Foundation

struct SearchResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashPhoto]
}
