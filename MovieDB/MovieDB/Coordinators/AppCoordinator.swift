//
//  AppCoordinator.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class AppCoordinator {
    private var window: UIWindow
    private var navigationController: UINavigationController
    private var moviesCoordinator: MoviesCoordinator

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.moviesCoordinator = MoviesCoordinator(navigationController: navigationController)
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        moviesCoordinator.start()
    }
}
