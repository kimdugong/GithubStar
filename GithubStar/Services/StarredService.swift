//
//  StarredService.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/01.
//

import Foundation
import CoreData

public class StarredService {
    let coreDataStack: CoreDataStack

    public init(provider: Provider = .production) {
        switch provider {
        case .production:
            self.coreDataStack = CoreDataStack()
        case .mock:
            self.coreDataStack = TestCoreDataStack()
        }
    }

    public func getStarreds() -> [Starred]? {
        return coreDataStack.fetch(request: Starred.fetchRequest())
    }
    
    public func getStarred(user: User) -> [Starred]? {
        do {
            let request = Starred.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", user.name)
            let fetchResult = try coreDataStack.context.fetch(request)
            return fetchResult
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }

    public func add(user: User) -> Starred {
        let starred = Starred(context: coreDataStack.context)
        starred.id = Int32(user.id)
        starred.name = user.name
        starred.avatar = user.avatar

        coreDataStack.saveContext()
        return starred
    }

    public func delete(starred: Starred) -> Starred {
        return coreDataStack.delete(object: starred)
    }

    public func update(starred: Starred) -> Starred {
        return coreDataStack.update(object: starred)
    }
}
