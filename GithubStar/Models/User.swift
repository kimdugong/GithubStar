//
//  User.swift
//  GithubStar
//
//  Created by Dugong on 2021/11/30.
//

import Foundation

public struct User: Codable {
    private enum CodingKeys: String, CodingKey { case name = "login", avatar = "avatar_url" }
    
    let name: String
    let avatar: String
    var isStarred: Bool?
}
