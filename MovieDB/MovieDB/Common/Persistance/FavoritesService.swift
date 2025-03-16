//
//  FavoritesService.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

final class FavoritesService {

    static let shared = FavoritesService()

    private var favoriteMovieIDs: Set<Int> = []

    func loadFavorites() {
        let movies = RealmService.shared.getMovies()
        favoriteMovieIDs = Set(movies.map { $0.id })
    }

    func addMovieToFavorites(movie: Movie) {
        RealmService.shared.saveMovie(movie)
        favoriteMovieIDs.insert(movie.id)
    }

    func removeMovieFromFavorites(movieID: Int) {
        if let movie = RealmService.shared.getMovies().first(where: { $0.id == movieID }) {
            RealmService.shared.deleteMovie(movie)
            favoriteMovieIDs.remove(movieID)
        }
    }

    func isMovieFavorite(movieID: Int) -> Bool {
        return RealmService.shared.isMovieSaved(movieID)
    }
}
