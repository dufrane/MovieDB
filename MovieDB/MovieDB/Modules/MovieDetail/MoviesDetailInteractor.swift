//
//  MoviesDetailInteractor.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 12.03.2025.
//

import Foundation

protocol MovieDetailInteractorProtocol: AnyObject {
    func fetchMovieDetail(movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void)
    func fetchMovieCast(movieID: Int, completion: @escaping (Result<[Actor], Error>) -> Void)
}

final class MovieDetailInteractor: MovieDetailInteractorProtocol {
 
    private let apiService = APIService()

    func fetchMovieDetail(movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        apiService.fetchMovieDetail(movieID: movieID) { result in
            DispatchQueue.main.async { // 👈 Важливо!
                completion(result)
            }
        }
    }

    func fetchMovieCast(movieID: Int, completion: @escaping (Result<[Actor], Error>) -> Void) {
        apiService.fetchMovieCast(movieID: movieID) { result in
            DispatchQueue.main.async { // 👈 Важливо!
                completion(result)
            }
        }
    }

}
