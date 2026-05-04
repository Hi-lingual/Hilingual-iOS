//
//  CoreDataStorage.swift
//  HilingualData
//
//  Created by 진소은 on 11/12/25.
//

import CoreData

@MainActor
public final class CoreDataStorage {
    public static let shared = CoreDataStorage()

    private init() {}

    // MARK: - Managed Object Model
    
    private static var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.module.url(forResource: "LocalDB", withExtension: "momd") else {
            fatalError("LocalDB.momd not found in Bundle.module")
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load NSManagedObjectModel from: \(modelURL)")
        }

        return model
    }()

    // MARK: - Persistent Container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: "LocalDB",
            managedObjectModel: CoreDataStorage.managedObjectModel
        )

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Persistent store load error: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()

    // MARK: - Contexts
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }()
}
