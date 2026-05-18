import Foundation
import CoreData 

class PersistentContainer {
    static let shared = PersistentContainer()

    private init() {}

    // MARK: - Helpers

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
            AppLogger.error(loadError, context: "Core Data store loading")
            assertionFailure("Unresolved error \(loadError), \(loadError.userInfo)")

            let fallbackContainer = NSPersistentContainer(name: "db")
            let fallbackDescription = NSPersistentStoreDescription()
            fallbackDescription.type = NSInMemoryStoreType
            fallbackContainer.persistentStoreDescriptions = [fallbackDescription]
            fallbackContainer.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    AppLogger.error(error, context: "Fallback Core Data store loading")
                    assertionFailure("Fallback store error \(error), \(error.userInfo)")
                }
            }
            return configure(fallbackContainer)
        }

        return configure(container)
    }()
}
