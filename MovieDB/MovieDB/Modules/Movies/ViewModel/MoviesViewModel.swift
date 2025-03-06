//
//  MoviesViewModel.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import Foundation

final class MoviesViewModel {
    private weak var coordinator: MoviesCoordinator?
    private let apiService = APIService()
    private let favoritesService = FavoritesService()
    
    var movies: [Movie] = []
    var favoriteMovies: Set<Int64> = []
    
    init(coordinator: MoviesCoordinator) {
        self.coordinator = coordinator
        loadFavoriteMovies()
    }
    
// MARK: - Fetch movies
    func fetchMovies() {
        apiService.fetchMovies(from: .popular) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.updateFavorites()
                case .failure(let error):
                    print("Failed to fetch movies:", error.localizedDescription)
                }
            }
        }
    }
    
// MARK: - Fetch movies by category
        func fetchMovies(from category: APIService.MovieEndpoint, completion: @escaping () -> Void) {
            apiService.fetchMovies(from: category) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        self?.movies = movies
                        completion()
                    case .failure(let error):
                        print("Failed to fetch category movies:", error.localizedDescription)
                        completion()
                    }
                }
            }
        }
        
// MARK: - Search movies
    func searchMovies(query: String, completion: @escaping () -> Void) {
        apiService.fetchMovies(from: .search(query: query)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    print("Search failed:", error.localizedDescription)
                }
            }
        }
    }
    
// MARK: - Favorite movie handling
    func toggleFavorite(movie: Movie) {
        let movieID = Int64(movie.id)
        if favoriteMovies.contains(movieID) {
            favoritesService.removeMovieFromFavorites(movieID: movie.id)
            favoriteMovies.remove(movieID)
        } else {
            favoritesService.addMovieToFavorites(movie: movie)
            favoriteMovies.insert(movieID)
        }
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoriteMovies.contains(Int64(movie.id))
    }
    
    private func loadFavoriteMovies() {
        let savedFavorites = favoritesService.fetchFavoriteMovies().map { $0.id }
        favoriteMovies = Set(savedFavorites)
    }
    
    private func updateFavorites() {
        for movie in movies {
            let movieID = Int64(movie.id)
            if favoritesService.isMovieFavorite(movieID: movie.id) {
                favoriteMovies.insert(movieID)
            } else {
                favoriteMovies.remove(movieID)
            }
        }
    }
}
