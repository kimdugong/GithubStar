//
//  GithubStarTests.swift
//  GithubStarTests
//
//  Created by Dugong on 2021/11/30.
//

import XCTest
import Moya
import RxBlocking
@testable import GithubStar

class GithubStarTests: XCTestCase {

    var starredService: StarredService!
    var coreDataStack: CoreDataStack!
    var network: Network!

    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        starredService = StarredService(provider: .mock)
        network = Network(provider: .mock)
    }

    override func tearDownWithError() throws {
        starredService = nil
        coreDataStack = nil
        network = nil
    }

    func testAddStarred() throws {
        let user = User(id: 12345, name: "dugong", avatar: "https://avatar.com")
        let starred = starredService.add(user: user)

        XCTAssertEqual(starred.name, "dugong")
        XCTAssertEqual(starred.avatar, "https://avatar.com")
    }

    func testFetchStarred() throws {
        let user = User(id: 12345, name: "dugong", avatar: "https://avatar.com")
        let _ = starredService.add(user: user)
        let starreds = starredService.getStarreds()

        XCTAssertNotNil(starreds)
        XCTAssertEqual(starreds?.count, 1)
    }

    func testDeleteStarred() throws {
        let user = User(id: 12345, name: "dugong", avatar: "https://avatar.com")
        let starred = starredService.add(user: user)
        var starredList = starredService.getStarreds()
        XCTAssertEqual(starredList?.count, 1)

        let _ = starredService.delete(starred: starred)
        starredList = starredService.getStarreds()

        XCTAssertEqual(starredList?.isEmpty, true)
    }

    func testUpdateStarred() throws {
        let user = User(id: 12345, name: "dugong", avatar: "https://avatar.com")
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
    
    func testSearchUsers() throws {
        let users = network.getUsers(name: "mojombo", page: 1)
        let result = try users.toBlocking(timeout: 2).first()?.items.first
        XCTAssertEqual(result?.avatar, "https://secure.gravatar.com/avatar/25c7c18223fb42a4c6ae1c8db6f50f9b?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")
        XCTAssertEqual(result?.name, "mojombo")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
