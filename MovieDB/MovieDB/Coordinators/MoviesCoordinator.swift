//
//  MoviesCoordinator.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class MoviesCoordinator {
    
    let navigationController: UINavigationController
    private let movieDetailCoordinator: MovieDetailCoordinator

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.movieDetailCoordinator = MovieDetailCoordinator(navigationController: navigationController)
    }

    func start() -> UIViewController {
        let moviesVC = MoviesBuilder.build(coordinator: self, detailCoordinator: movieDetailCoordinator)
        navigationController.setViewControllers([moviesVC], animated: false)
        return moviesVC
    }
}
