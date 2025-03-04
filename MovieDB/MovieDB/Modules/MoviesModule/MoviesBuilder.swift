//
//  MoviesBuilder.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class MoviesBuilder {
    static func build(navigationController: UINavigationController) -> UIViewController {
        let router = MoviesRouter(navigationController: navigationController)
        let interactor = MoviesInteractor()
        let presenter = MoviesPresenter(interactor: interactor, router: router)
        let viewController = MoviesViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
