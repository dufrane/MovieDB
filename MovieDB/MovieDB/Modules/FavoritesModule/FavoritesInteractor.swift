//
//  FavoritesInteractor.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 10.03.2025.
//

import Foundation

protocol FavoritesInteractorProtocol: AnyObject {
    func fetchFavoriteMovies(completion: @escaping ([Movie]) -> Void)
}

final class FavoritesInteractor: FavoritesInteractorProtocol {


    func fetchFavoriteMovies(completion: @escaping ([Movie]) -> Void) {
        let movies = RealmService.shared.getMovies()
        completion(movies)
    }

    func addMovieToFavorites(movie: Movie) {
        RealmService.shared.saveMovie(movie)
    }

    func removeMovieFromFavorites(movieID: Int) {
        if let movie = RealmService.shared.getMovies().first(where: { $0.id == movieID }) {
            RealmService.shared.deleteMovie(movie)
        }
    }

    func isMovieFavorite(movieID: Int) -> Bool {
        return RealmService.shared.isMovieSaved(movieID)
    }

}

