//
//  RealmMovie.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 16.03.2025.
//

import RealmSwift

class RealmMovie: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String = ""
    @Persisted var overview: String = ""
    @Persisted var posterPath: String? = ""
    @Persisted var releaseDate: String?
    @Persisted var voteAverage: Double = 0.0

    convenience init(movie: Movie) {
        self.init()
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
    }
}

extension Movie {
    init(from realmMovie: RealmMovie) {
        self.id = realmMovie.id
        self.title = realmMovie.title
        self.overview = realmMovie.overview
        self.posterPath = realmMovie.posterPath
        self.releaseDate = realmMovie.releaseDate
        self.voteAverage = realmMovie.voteAverage
        self.isFavorite = true
    }
}

