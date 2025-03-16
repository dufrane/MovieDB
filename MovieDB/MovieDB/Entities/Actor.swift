//
//  Actor.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import Foundation

struct Actor: Decodable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?

    var profileURL: URL? {
        guard let path = profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
}

