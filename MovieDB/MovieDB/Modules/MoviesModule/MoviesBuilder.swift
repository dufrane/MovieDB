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

        let viewController = MoviesViewController(presenter: nil)

        if let view = viewController as? MoviesViewProtocol {
            let presenter = MoviesPresenter(view: view, interactor: interactor, router: router)
            viewController.presenter = presenter
        }

        return viewController
    }
}
