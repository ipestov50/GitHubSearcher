//
//  Repository.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 24.11.2022.
//

import Foundation

struct Repository: Codable, Comparable {
    static func < (lhs: Repository, rhs: Repository) -> Bool {
        lhs.name.lowercased() < rhs.name.lowercased()
    }
    
    var id: Int
    var node_id: String?
    var name: String
    var html_url: String?
    var description: String?
    var visibility: String?
    var language: String?
    var updated_at: String
    var owner: Owner
 
    var isLiked: Bool?
    var isSeen: Bool?
    
}

struct Results: Codable {
    var items: [Repository]?
}

struct Owner: Codable, Hashable {

    var login: String
}
