// MARK: - Core Data Entity Extensions
// File: MedWall/Core/CoreData/Entities/MedicalFactEntity+CoreDataClass.swift

import CoreData
import Foundation

@objc(MedicalFactEntity)
public class MedicalFactEntity: NSManagedObject {
    
}

extension MedicalFactEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicalFactEntity> {
        return NSFetchRequest<MedicalFactEntity>(entityName: "MedicalFactEntity")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var category: String?
    @NSManaged public var specialty: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var source: String?
    @NSManaged public var tags: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var lastShown: Date?
    @NSManaged public var timesShown: Int32
    @NSManaged public var userRating: Int16
}
