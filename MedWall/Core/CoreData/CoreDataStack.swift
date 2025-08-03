// MARK: - Core Data Stack
// File: MedWall/Core/CoreData/CoreDataStack.swift

import CoreData
import Foundation

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MedWall")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                Logger.shared.log("Core Data error: \(error)", level: .error)
                fatalError("Core Data error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                Logger.shared.log("Save error: \(error)", level: .error)
            }
        }
    }
    
    private init() {}
}
