//
//  CoreDataStack.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

// MARK: - Persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDB")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

// MARK: - Context
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

// MARK: - Save context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving Core Data context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
