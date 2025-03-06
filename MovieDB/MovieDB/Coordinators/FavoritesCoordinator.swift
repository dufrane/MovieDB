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

final class FavoritesCoordinator: FavoritesCoordinatorProtocol {
    let navigationController: UINavigationController
    weak var parentCoordinator: TabBarCoordinator?
    private let movieDetailCoordinator: MovieDetailCoordinator
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.movieDetailCoordinator = MovieDetailCoordinator(navigationController: navigationController)
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
        
        let detailVC = MovieDetailBuilder.build(with: convertedMovie, coordinator: movieDetailCoordinator)
        
        navigationController.pushViewController(detailVC, animated: true)
    }
}
