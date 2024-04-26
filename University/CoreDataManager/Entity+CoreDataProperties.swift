//
//  Entity+CoreDataProperties.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 26.04.2024.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?

}

extension Entity : Identifiable {

}
