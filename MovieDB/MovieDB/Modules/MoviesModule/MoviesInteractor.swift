//
//  MoviesInteractor.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 06.03.2025.
//

import Foundation

protocol MoviesInteractorProtocol: AnyObject {
    func fetchMovies(from category: APIService.MovieEndpoint, completion: @escaping (Result<[Movie], Error>) -> Void)
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
}

final class MoviesInteractor {
    weak var presenter: MoviesPresenterProtocol?
    private let apiService = APIService()
}

extension MoviesInteractor: MoviesInteractorProtocol {
    func fetchMovies(from category: APIService.MovieEndpoint, completion: @escaping (Result<[Movie], Error>) -> Void) {
        apiService.fetchMovies(from: category) { result in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        apiService.fetchMovies(from: .search(query: query), completion: completion)
    }
}
