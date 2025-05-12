//
//  Post.swift
//  designUp
//
//  Created by София Кармаева on 2/4/2025.
//

import Foundation

struct Post: Codable, Identifiable {
    var id: Int {
        post_id
    }
    let post_id: Int
    let author_login: String
    let photo: String
    let tags: [String]
    let date_posted: String
    var likes: Int = 0
}

