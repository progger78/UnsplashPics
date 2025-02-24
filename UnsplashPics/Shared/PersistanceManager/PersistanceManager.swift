//
//  PersistanceManager.swift
//  UnsplashPics
//
//  Created by 1 on 04.12.2024.
//

import Foundation

class PersistanceManager {
    
    static let shared = PersistanceManager()
    
    enum PersistanceActionType { case add, remove }
    enum Keys { static let favorites = "Favorites" }
    
    private let defaults = FavoritePhotosUserDefaults.shared
   
    private init() { }
    
    
    func retrieveFavorites() -> [DetailPhoto] {
        if let favorites = defaults.get(forKey: Keys.favorites) {
            return favorites
        }
        return []
    }
 
    private func save(favorites: [DetailPhoto]) {
            defaults.append(favorites, forKey: Keys.favorites)
    }
    
    func updateWith(favorite: DetailPhoto, actionType: PersistanceActionType) throws {

        var favorites = retrieveFavorites()
    
        switch actionType {
        case .add:
            guard !favorites.contains(favorite) else { throw PersistanceError.alreadyInFavorites }
            
            favorites.append(favorite)
        case .remove:
            favorites.removeAll { $0.id == favorite.id }
            
        }
        save(favorites: favorites)
    }
}

