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

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    public func getStarreds() -> [Starred]? {
        return coreDataStack.fetch(request: Starred.fetchRequest())
    }

    public func add(user: User) -> Starred {
        let starred = Starred(context: coreDataStack.context)
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
