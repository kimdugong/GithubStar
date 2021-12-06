//
//  API.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/04.
//

import Foundation
import Moya

enum Github {
    case fetchUsers(name: String, page: Int)
}

extension Github: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .fetchUsers(_, _):
            return "/search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchUsers(_, _):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchUsers(let name, let page):
            return .requestParameters(parameters: ["q": name, "page": page], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/vnd.github.v3+json"]
    }
    
    var validationType: ValidationType {
        switch self {
        case .fetchUsers(_, _):
            return .successCodes
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchUsers(_, _):
            return """
                        {
                          "total_count": 12,
                          "incomplete_results": false,
                          "items": [
                            {
                              "login": "mojombo",
                              "id": 1,
                              "node_id": "MDQ6VXNlcjE=",
                              "avatar_url": "https://secure.gravatar.com/avatar/25c7c18223fb42a4c6ae1c8db6f50f9b?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                              "gravatar_id": "",
                              "url": "https://api.github.com/users/mojombo",
                              "html_url": "https://github.com/mojombo",
                              "followers_url": "https://api.github.com/users/mojombo/followers",
                              "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
                              "organizations_url": "https://api.github.com/users/mojombo/orgs",
                              "repos_url": "https://api.github.com/users/mojombo/repos",
                              "received_events_url": "https://api.github.com/users/mojombo/received_events",
                              "type": "User",
                              "score": 1,
                              "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
                              "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
                              "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
                              "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
                              "site_admin": true
                            }
                          ]
                        }
                        """
                .data(using: .utf8)!
        }
    }
    
    
}
