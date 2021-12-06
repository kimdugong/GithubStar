//
//  User.swift
//  GithubStar
//
//  Created by Dugong on 2021/11/30.
//

import Foundation
import RxDataSources

public struct User: Codable, IdentifiableType, Equatable {
    public var identity: Int32 {
        return id
    }
    
    public typealias Identity = Int32
    
    
    private enum CodingKeys: String, CodingKey { case name = "login", avatar = "avatar_url", id }
    
    public var id: Int32
    let name: String
    let avatar: String
    var isStarred: Bool?
}
