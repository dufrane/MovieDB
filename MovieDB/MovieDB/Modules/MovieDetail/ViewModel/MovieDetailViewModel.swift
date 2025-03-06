//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import Foundation

final class MovieDetailViewModel {
    var coordinator: MovieDetailCoordinator?
    private let apiService: APIService
    
    var movieDetail: MovieDetail?
    var cast: [Actor] = []
    var errorMessage: String?
    
    init(coordinator: MovieDetailCoordinator, apiService: APIService) {
        self.coordinator = coordinator
        self.apiService = apiService
    }
    
// MARK: - Fetch Movie Detail
    func fetchMovieDetail(movieID: Int, completion: @escaping () -> Void) {
        apiService.fetchMovieDetail(movieID: movieID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.movieDetail = detail
                    print("Movie Detail Loaded:", detail)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error loading movie details:", error.localizedDescription)
                }
                completion()
            }
        }
    }
    
// MARK: - Fetch Movie Cast
    func fetchMovieCast(movieID: Int, completion: @escaping () -> Void) {
        apiService.fetchMovieCast(movieID: movieID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cast):
                    self?.cast = cast
                    print("Cast Loaded:", cast.count, "actors")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error loading cast:", error.localizedDescription)
                }
                completion()
            }
        }
    }
    
// MARK: - Select Movie
    func didSelectMovie(movie: Movie) {
        coordinator?.start(with: movie)
    }
    
// MARK: - Close Detail Screen
    func closeDetailScreen() {
        coordinator?.closeMovieDetail()
    }
}
