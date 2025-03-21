//
//  FavoritesBuilder.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 10.03.2025.
//

import UIKit

final class FavoritesBuilder {
    static func build(navigationController: UINavigationController) -> UIViewController {
        let router = FavoritesRouter(navigationController: navigationController)
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter(interactor: interactor, router: router)
        let viewController = FavoritesViewController(presenter: presenter)
        presenter.view = viewController 
        print("✅ view set in Presenter: \(presenter.view != nil)")
        return viewController
    }
}
