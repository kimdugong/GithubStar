//
//  GithubResponse.swift
//  GithubStar
//
//  Created by Dugong on 2021/12/05.
//

import Foundation

struct GithubResponse<T: Codable>: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count", isIncompleted = "incomplete_results", items
    }
    
    let totalCount: Int
    let isIncompleted: Bool
    let items: [T]
}
