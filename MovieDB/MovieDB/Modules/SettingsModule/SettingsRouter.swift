//
//  SettingsRouter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 16.03.2025.
//

import UIKit

protocol SettingsRouterProtocol {
    func navigateToSettings()
}

final class SettingsRouter: SettingsRouterProtocol {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func navigateToSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

