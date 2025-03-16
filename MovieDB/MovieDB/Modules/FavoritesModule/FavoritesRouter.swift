//
//  FavoritesRouter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 10.03.2025.
//

import UIKit

protocol FavoritesRouterProtocol: AnyObject {
    func navigateToMovieDetail(movie: Movie)
}

final class FavoritesRouter: FavoritesRouterProtocol {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigateToMovieDetail(movie: Movie) {
        guard let navigationController = navigationController else { return }
        let detailVC = MovieDetailBuilder.build(movie: movie, navigationController: navigationController)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
