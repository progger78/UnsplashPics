//
//  CoinsUserDefaults.swift
//  CryptoInfo
//
//  Created by 1 on 04.12.2024.
//

import Foundation


class FavoritePhotosUserDefaults {
    static let shared = FavoritePhotosUserDefaults()
    
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private init() {}
    
    func append(_ object: [DetailPhoto], forKey key: String) {
        guard let photos = try? encoder.encode(object) else { return }
        
        userDefaults.set(photos, forKey: key)
    }
    
    func get(forKey key: String) -> [DetailPhoto]? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        
        do {
            return try decoder.decode([DetailPhoto].self, from: data)
        } catch {
            return nil
        }
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
