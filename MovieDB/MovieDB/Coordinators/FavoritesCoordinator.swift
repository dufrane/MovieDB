//
//  FavoritesCoordinator.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit

protocol FavoritesCoordinatorProtocol {
    func start() -> UIViewController
    func showMovieDetail(movie: FavoriteMovie)
}

final class FavoritesCoordinator: FavoritesCoordinatorProtocol, MovieDetailCoordinatorProtocol {
    let navigationController: UINavigationController
    weak var parentCoordinator: TabBarCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() -> UIViewController {
        let favoritesVC = FavoritesViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.coordinator = self
        navigationController.setViewControllers([favoritesVC], animated: false)
        return favoritesVC
    }

    func showMovieDetail(movie: FavoriteMovie) {
        let convertedMovie = Movie(
            id: Int(movie.id),
            title: movie.title ?? "",
            overview: "",
            posterPath: movie.posterPath,
            releaseDate: nil,
            voteAverage: 0.0
        )

        let apiService = APIService()
        let viewModel = MovieDetailViewModel(coordinator: self, apiService: apiService)
        let detailVC = MovieDetailViewController(viewModel: viewModel, movie: convertedMovie) 

        navigationController.pushViewController(detailVC, animated: true)
    }

    func closeMovieDetail() {
        navigationController.popViewController(animated: true)
    }
}
