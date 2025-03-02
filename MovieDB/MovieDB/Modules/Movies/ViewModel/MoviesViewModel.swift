//
//  MoviesViewModel.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import Foundation
import Combine

final class MoviesViewModel: ObservableObject {
    private weak var coordinator: MoviesCoordinator?
    private let apiService = APIService()
    private let favoritesService = FavoritesService()
    @Published var movies: [Movie] = []
    @Published var favoriteMovies: Set<Int64> = []
    var cancellables = Set<AnyCancellable>()

    init(coordinator: MoviesCoordinator) {
        self.coordinator = coordinator
        loadFavoriteMovies()
    }

    func fetchMovies() {
        apiService.fetchMovies(from: .popular)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch movies:", error)
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
                self?.updateFavorites()

            })
            .store(in: &cancellables)
    }

    func didSelectMovie(movie: Movie) {
        coordinator?.start(with: movie)
    }
    
    func searchMovies(query: String) {
        apiService.fetchMovies(from: .search(query: query))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }
    
    func fetchMovies(from category: APIService.MovieEndpoint) {
        apiService.fetchMovies(from: category)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch movies:", error)
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }
    
    func toggleFavorite(movie: Movie) {
        if favoriteMovies.contains(Int64(movie.id)) {
                favoritesService.removeMovieFromFavorites(movieID: movie.id)
            favoriteMovies.remove(Int64(movie.id))
            } else {
                favoritesService.addMovieToFavorites(movie: movie)
                favoriteMovies.insert(Int64(movie.id))
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
                if favoritesService.isMovieFavorite(movieID: movie.id) {
                    favoriteMovies.insert(Int64(movie.id))
                } else {
                    favoriteMovies.remove(Int64(movie.id))
                }
            }
        }
}
