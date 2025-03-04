//
//  SceneDelegate.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let keychainService = KeychainService()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        let moviesModule = MoviesBuilder.build(navigationController: navigationController)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        validateAPIKey()
        navigationController.setViewControllers([moviesModule], animated: false)
    }
    
// MARK: - Validate API Key
    private func validateAPIKey() {
        guard let apiKey = keychainService.getAPIKey() else {
            requestAPIKey()
            return
        }
        
        keychainService.validateAPIKey { [weak self] isValid in
            DispatchQueue.main.async {
                if isValid {
                    print("API Key is valid. Proceeding with the app.")
                } else {
                    print("Invalid API Key. Requesting a new one...")
                    self?.keychainService.deleteAPIKey()
                    self?.requestAPIKey()
                }
            }
        }
    }
    
// MARK: - Request API Key UIAlertController
    private func requestAPIKey() {
        guard let rootVC = window?.rootViewController else { return }
        
        let alert = UIAlertController(title: "Enter API Key", message: "Please enter a valid API key to continue.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "API Key"
            textField.isSecureTextEntry = true
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let apiKey = alert?.textFields?.first?.text, !apiKey.isEmpty else {
                self?.requestAPIKey()
                return
            }
            
            self?.keychainService.saveAPIKey(apiKey)
            
            self?.keychainService.validateAPIKey { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        print("API Key saved and valid. Proceeding...")
                    } else {
                        print("Invalid API Key entered.")
                        self?.keychainService.deleteAPIKey()
                        self?.requestAPIKey()
                    }
                }
            }
        }
        
        alert.addAction(saveAction)
        rootVC.present(alert, animated: true)
    }
}
