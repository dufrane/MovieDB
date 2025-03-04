//
//  MoviesBuilder.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class MoviesBuilder {
    static func build(coordinator: MoviesCoordinator, detailCoordinator: MovieDetailCoordinator) -> MoviesViewController {
        let moviesViewModel = MoviesViewModel(coordinator: coordinator)
        let movieDetailViewModel = MovieDetailViewModel(coordinator: detailCoordinator, apiService: APIService())
        let viewController = MoviesViewController(viewModel: moviesViewModel, detailViewModel: movieDetailViewModel)
        return viewController
    }
}
