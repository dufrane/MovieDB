//
//  MovieDetailCoordinator.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit

protocol MovieDetailCoordinatorProtocol {
    func closeMovieDetail()
}

final class MovieDetailCoordinator: MovieDetailCoordinatorProtocol {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func start(with movie: Movie) {
        let viewModel = MovieDetailViewModel(coordinator: self, apiService: APIService())
        let detailVC = MovieDetailViewController(viewModel: viewModel, movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func closeMovieDetail() {
        navigationController?.popViewController(animated: true)
    }
}
