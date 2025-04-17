//
//  Favourite.swift
//  designUp
//
//  Created by София Кармаева on 2/4/2025.
//

import Foundation

struct Favourite: Codable, Identifiable {
    let id: Int
    let owner_login: String
    let post_id: Int
}
