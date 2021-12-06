//
//  PersistenceManager.swift
//  GithubStar
//
//  Created by Dugong on 2021/11/30.
//

import Foundation
import CoreData

open class CoreDataStack {
    public static let name = "GithubStar"

    public static var shared: CoreDataStack = {
        return CoreDataStack()
    }()

    public init() {}

    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: name, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    public lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: CoreDataStack.name,
            managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    public var context: NSManagedObjectContext {
        return container.viewContext
    }

    // MARK: - Core Data stack

//    public lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving support

    public func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    public func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        do {
            request.sortDescriptors = [.init(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
            let fetchResult = try context.fetch(request)
            return fetchResult
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }

    public func update<T: NSManagedObject>(object: T) -> T {
        saveContext()
        return object
    }

    @discardableResult
    public func delete<T: NSManagedObject>(object: T) -> T {
        context.delete(object)
        saveContext()
        return object
    }

    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
}
