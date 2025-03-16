//
//  MovieDetailBuilder.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit

import UIKit

final class MovieDetailBuilder {
    static func build(movie: Movie, navigationController: UINavigationController) -> UIViewController {
        let router = MovieDetailRouter()
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter(interactor: interactor, movieID: movie.id)
        let viewController = MovieDetailViewController(presenter: presenter, movie: movie)

        presenter.view = viewController 

        return viewController
    }
}
