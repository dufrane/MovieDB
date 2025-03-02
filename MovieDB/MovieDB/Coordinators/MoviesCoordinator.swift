//
//  MoviesCoordinator.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class MoviesCoordinator: MovieDetailCoordinatorProtocol {
    
    let navigationController: UINavigationController


    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() -> UIViewController {
        let moviesViewModel = MoviesViewModel(coordinator: self)
        let moviesVC = MoviesViewController(viewModel: moviesViewModel)
        moviesVC.title = "Movies"
        navigationController.setViewControllers([moviesVC], animated: false)
        return moviesVC
    }

    func start(with movie: Movie) {
        let viewModel = MovieDetailViewModel(coordinator: self, apiService: APIService())
        let detailVC = MovieDetailViewController(viewModel: viewModel, movie: movie)
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    func closeMovieDetail() {
        navigationController.popViewController(animated: true)
    }
    
}
