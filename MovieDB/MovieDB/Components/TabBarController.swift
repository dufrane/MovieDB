//
//  TabBarController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configureTabBarAppearance()
    }

    private func setupTabBar() {
        let moviesNavigationController = UINavigationController()
        let moviesModule = MoviesBuilder.build(navigationController: moviesNavigationController)
        moviesNavigationController.setViewControllers([moviesModule], animated: false)
        moviesNavigationController.tabBarItem = UITabBarItem(
            title: "Movies",
            image: UIImage(systemName: "film"),
            tag: 0
        )

        let favoritesNavigationController = UINavigationController()
        let favoritesModule = FavoritesBuilder.build(navigationController: favoritesNavigationController)
        favoritesNavigationController.setViewControllers([favoritesModule], animated: false)
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star"),
            tag: 1
        )

        let settingsNavigationController = UINavigationController()
        let settingsRouter = SettingsRouter(navigationController: settingsNavigationController)
        let settingsVC = SettingsViewController()
        settingsNavigationController.setViewControllers([settingsVC], animated: false)
        settingsNavigationController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 2
        )

        viewControllers = [
            moviesNavigationController,
            favoritesNavigationController,
            settingsNavigationController
        ]
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.tintColor = .systemBlue
    }
}
