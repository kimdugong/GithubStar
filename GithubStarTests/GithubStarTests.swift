//
//  GithubStarTests.swift
//  GithubStarTests
//
//  Created by Dugong on 2021/11/30.
//

import XCTest
@testable import GithubStar

class GithubStarTests: XCTestCase {

    var starredService: StarredService!
    var coreDataStack: CoreDataStack!

    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        starredService = StarredService(coreDataStack: coreDataStack)
    }

    override func tearDownWithError() throws {
        starredService = nil
        coreDataStack = nil
    }

    func testAddStarred() throws {
        let user = User(name: "dugong", avatar: "https://avatar.com")
        let starred = starredService.add(user: user)

        XCTAssertEqual(starred.name, "dugong")
        XCTAssertEqual(starred.avatar, "https://avatar.com")
    }

    func testFetchStarred() throws {
        let user = User(name: "dugong", avatar: "https://avatar.com")
        let _ = starredService.add(user: user)
        let starreds = starredService.getStarreds()

        XCTAssertNotNil(starreds)
        XCTAssertEqual(starreds?.count, 1)
    }

    func testDeleteStarred() throws {
        let user = User(name: "dugong", avatar: "https://avatar.com")
        let starred = starredService.add(user: user)
        var starredList = starredService.getStarreds()
        XCTAssertEqual(starredList?.count, 1)

        let _ = starredService.delete(starred: starred)
        starredList = starredService.getStarreds()

        XCTAssertEqual(starredList?.isEmpty, true)
    }

    func testUpdateStarred() throws {
        let user = User(name: "dugong", avatar: "https://avatar.com")
        let starred = starredService.add(user: user)

        XCTAssertEqual(starred.name, "dugong")
        XCTAssertEqual(starred.avatar, "https://avatar.com")

        starred.name = "kimdugong"
        starred.avatar = "https://avatar2.com"
        let _ = starredService.update(starred: starred)

        let starredList = starredService.getStarreds()
        XCTAssertEqual(starredList?.count, 1)
        XCTAssertEqual(starredList?.first?.name, "kimdugong")
        XCTAssertEqual(starredList?.first?.avatar, "https://avatar2.com")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
