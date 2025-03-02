//
//  SceneDelegate.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabBarCoordinator: TabBarCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarCoordinator = TabBarCoordinator()
        self.tabBarCoordinator = tabBarCoordinator
        
        let tabBarController = TabBarController(tabBarCoordinator: tabBarCoordinator)
        window.rootViewController = tabBarController
        window.overrideUserInterfaceStyle = .dark
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
