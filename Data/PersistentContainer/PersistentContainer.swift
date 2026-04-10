//
//  PersistentContainer.swift
//  Plateh.th
//
//  Created by Adis on 16.03.2026.
//

import Foundation
import CoreData 
class PersistentContainer {
    static let shared = PersistentContainer()
    private init() {}

    private func configure(_ container: NSPersistentContainer) -> NSPersistentContainer {
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "db")
        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        var loadError: NSError?
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                loadError = error
            }
        }

        if let loadError {
            assertionFailure("Unresolved error \(loadError), \(loadError.userInfo)")

            let fallbackContainer = NSPersistentContainer(name: "db")
            let fallbackDescription = NSPersistentStoreDescription()
            fallbackDescription.type = NSInMemoryStoreType
            fallbackContainer.persistentStoreDescriptions = [fallbackDescription]
            fallbackContainer.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    assertionFailure("Fallback store error \(error), \(error.userInfo)")
                }
            }
            return configure(fallbackContainer)
        }

        return configure(container)
    }()
}
