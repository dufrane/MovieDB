//
//  MoviesRouter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 06.03.2025.
//

import UIKit

protocol MoviesRouterProtocol: AnyObject {
    func navigateToMovieDetail(movie: Movie)
}

final class MoviesRouter: MoviesRouterProtocol {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigateToMovieDetail(movie: Movie) {
//        let detailVC = MovieDetailBuilder.build(movie: movie)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
}
