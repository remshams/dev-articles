//
//  Persistence.swift
//  CoreDataPlain
//
//  Created by Mathias Remshardt on 20.03.21.
//

import CoreData

struct PersistenceController {
  let context: NSManagedObjectContext

  private let container: NSPersistentContainer

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "DevArticles")
    context = container.viewContext
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores(completionHandler: { _, error in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
  }

  func save() throws {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        throw RepositoryError.error
      }
    }
  }
}
