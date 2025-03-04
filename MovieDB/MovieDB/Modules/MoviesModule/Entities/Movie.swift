//
//  MoviesEntities.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 08.03.2025.
//

import Foundation

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

struct MoviesResponse: Codable {
    let results: [Movie]
}
