//
//  Entity+CoreDataProperties.swift
//  University
//
//  Created by Furkan Deniz Albaylar on 21.05.2024.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var address: String?
    @NSManaged public var email: String?
    @NSManaged public var fax: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var rector: String?
    @NSManaged public var website: String?

}

extension Entity : Identifiable {

}
