//
//  ImageLoader.swift
//  UnsplashPics
//
//  Created by 1 on 06.02.2025.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init(){}
    
    func fetchImage(for urlString: String) async -> UIImage? {
        if let cached = ImageCache.shared.get(forKey: urlString) {
            return cached
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            
            ImageCache.shared.set(image, forKey: urlString)
            return UIImage(data: data)
        } catch {
            return UIImage(systemName: "photo.circle.fill")
        }
    }
}
