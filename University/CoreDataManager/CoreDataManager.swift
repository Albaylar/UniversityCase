//
//  CoreDataManager.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 18.04.2024.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let context: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "University")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.context = persistentContainer.viewContext
    }
    
    private let entityName = "Entity"
    // Favori üniversiteyi kaydetmek için fonksiyon
    func saveFavoriteUniversity(university: University) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Entity could not be found")
        }
        
        let favoriteUniversity = NSManagedObject(entity: entity, insertInto: context)
        favoriteUniversity.setValue(university.name, forKeyPath: "name")
        favoriteUniversity.setValue(university.website, forKeyPath: "website")
        favoriteUniversity.setValue(university.adress, forKeyPath: "address")
        favoriteUniversity.setValue(university.rector, forKey: "rector")
        favoriteUniversity.setValue(university.email, forKeyPath: "email")
        favoriteUniversity.setValue(university.fax, forKeyPath: "fax")
        favoriteUniversity.setValue(university.phone, forKeyPath: "phone")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Favori üniversiteyi silmek için fonksiyon
    func deleteFavoriteUniversity(name: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            try results.forEach { result in
                if let obj = result as? NSManagedObject {
                    context.delete(obj)
                    try context.save()
                }
            }
        } catch let error as NSError {
            print("Deleting error: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    func fetchFavoriteUniversities() -> [University] {
        var favoriteUniversities: [University] = []
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                let name = result.value(forKey: "name") as? String
                let website = result.value(forKey: "website") as? String
                let phone = result.value(forKey: "phone") as? String
                let fax = result.value(forKey: "fax") as? String
                let email = result.value(forKey: "email") as? String
                let adress = result.value(forKey: "address") as? String
                let rector = result.value(forKey: "rector") as? String
                
                let university = University(name: name, phone: phone, fax: fax, website: website, email: email, adress: adress, rector: rector)
                
                favoriteUniversities.append(university)
            }
        } catch let error as NSError {
            print("Could not fetch favorites. \(error), \(error.userInfo)")
        }
        
        return favoriteUniversities
    }
    
    func isFavoriteUniversity(name: String) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if university is favorite: \(error.localizedDescription)")
            return false
        }
    }
    
}

struct FavoriteUniversity {
    let name: String
    // Add other properties based on your entity attributes
}


