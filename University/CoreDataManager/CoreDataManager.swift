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
    func saveFavoriteUniversity(name: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Entity could not be found")
        }

        let favoriteUniversity = NSManagedObject(entity: entity, insertInto: context)
        favoriteUniversity.setValue(name, forKeyPath: "name")

        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    // Favori üniversiteyi silmek için fonksiyon
    func deleteFavoriteUniversity(with name: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let results = try context.fetch(fetchRequest)
            if let objectToDelete = results.first as? NSManagedObject {
                context.delete(objectToDelete)
                try context.save()
            }
        } catch let error as NSError {
            print("Deleting error: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    func fetchFavoriteUniversities() -> [FavoriteUniversity] {
        var favoriteUniversities: [FavoriteUniversity] = []

        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Entity")
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                if let name = result.value(forKey: "name") as? String {
                    let favoriteUniversity = FavoriteUniversity(name: name)
                    favoriteUniversities.append(favoriteUniversity)
                }
            }
        } catch let error as NSError {
            print("Could not fetch favorites. \(error), \(error.userInfo)")
        }

        return favoriteUniversities
    }



}

struct FavoriteUniversity {
  let name: String
  // Add other properties based on your entity attributes
}


