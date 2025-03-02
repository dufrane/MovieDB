//
//  MovieDetailBuilder.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit

final class MovieDetailBuilder {
    static func build(with movie: Movie, coordinator: MovieDetailCoordinator) -> UIViewController {
        let apiService = APIService()
        let viewModel = MovieDetailViewModel(coordinator: coordinator, apiService: apiService)
        let viewController = MovieDetailViewController(viewModel: viewModel, movie: movie)
        viewModel.fetchMovieDetail(movieID: movie.id)
        return viewController
    }
}

