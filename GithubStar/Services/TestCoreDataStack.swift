//
//  TestCoreDataStack.swift
//  GithubStarTests
//
//  Created by Dugong on 2021/12/01.
//

import Foundation
import CoreData

class TestCoreDataStack: CoreDataStack {
    override init() {
        super.init()

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(
            name: CoreDataStack.name,
            managedObjectModel: CoreDataStack.model)
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        self.container = container
    }
}
