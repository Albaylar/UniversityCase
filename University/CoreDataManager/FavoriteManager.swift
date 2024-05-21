//
//  FavoriteManager.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//

import Foundation

final class FavoriteManager {
    static let shared = FavoriteManager()
    var favorites: [University] = []
    
    private init() { }
    
    func fetchData() {
        favorites = CoreDataManager.shared.fetchFavoriteUniversities()
    }
    
    func addNewFavorite(university: University) {
        CoreDataManager.shared.saveFavoriteUniversity(university: university)
        favorites.append(university)
    }
    
    func removeFromFavorites(university: University) {
        guard let universityName = university.name else { return }
        CoreDataManager.shared.deleteFavoriteUniversity(name: universityName)
        favorites.removeAll(where: {$0.name == universityName})
    }
  
}
