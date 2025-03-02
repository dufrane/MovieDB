//
//  TabBarCoordinator.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import UIKit

final class TabBarCoordinator {
    private let tabBarController: UITabBarController
    private let moviesCoordinator: MoviesCoordinator
    private let favoritesCoordinator: FavoritesCoordinator

    init() {
        self.tabBarController = UITabBarController()
        let moviesNavController = UINavigationController()
        let favoritesNavController = UINavigationController()

        self.moviesCoordinator = MoviesCoordinator(navigationController: moviesNavController)
        self.favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavController)
    }

    func start() -> UITabBarController {
        setupTabBar()
        return tabBarController
    }

    private func setupTabBar() {
        moviesCoordinator.start()
        favoritesCoordinator.start()

        moviesCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film"), selectedImage: UIImage(systemName: "film.fill"))
        favoritesCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))

        tabBarController.viewControllers = [moviesCoordinator.navigationController, favoritesCoordinator.navigationController]
    }
}
