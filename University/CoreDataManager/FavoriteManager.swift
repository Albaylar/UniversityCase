//
//  FavoriteManager.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    var favorites: [String] = []
    
    private init() { }
    
    func fetchData() {
        favorites = CoreDataManager.shared.fetchFavoriteUniversities()
    }
    
    func addNewFavorite(name: String) {
        CoreDataManager.shared.saveFavoriteUniversity(name: name)
        favorites.append(name)
    }
    
    func removeFromFavorites(name: String) {
        CoreDataManager.shared.deleteFavoriteUniversity(name: name)
        favorites.removeAll(where: {$0 == name})
    }
}
