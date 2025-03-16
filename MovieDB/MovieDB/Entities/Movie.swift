//
//  MoviesEntities.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 08.03.2025.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    init(id: Int, title: String, overview: String, posterPath: String?, releaseDate: String?, voteAverage: Double, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.isFavorite = isFavorite
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    var releaseYear: String {
        guard let releaseDate = releaseDate, !releaseDate.isEmpty else { return "Unknown" }
        return String(releaseDate.prefix(4))
    }
}

struct MoviesResponse: Codable {
    let results: [Movie]
}
