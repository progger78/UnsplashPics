//
//  ImageCache.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//


import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func set(_ object: UIImage, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> UIImage? {
        guard let image = cache.object(forKey: key as NSString) else { return nil }
        
        return image
    }
}
