//
//  MoviesInteractor.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 06.03.2025.
//

import Foundation

protocol MoviesInteractorProtocol: AnyObject {
    func fetchMovies(from category: APIService.MovieEndpoint, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func addMovieToFavorites(movie: Movie)
    func removeMovieFromFavorites(movieID: Int)
    func isMovieFavorite(movieID: Int) -> Bool
}

final class MoviesInteractor {
    private let apiService = APIService()
    private let favoritesService = FavoritesService()
}

extension MoviesInteractor: MoviesInteractorProtocol {
    func fetchMovies(from category: APIService.MovieEndpoint, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        apiService.fetchMovies(from: category, page: page) { result in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        apiService.fetchMovies(from: .search(query: query)) { result in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addMovieToFavorites(movie: Movie) {
        favoritesService.addMovieToFavorites(movie: movie)
    }

    func removeMovieFromFavorites(movieID: Int) {
        favoritesService.removeMovieFromFavorites(movieID: movieID)
    }

    func isMovieFavorite(movieID: Int) -> Bool {
        return favoritesService.isMovieFavorite(movieID: movieID)
    }
}



