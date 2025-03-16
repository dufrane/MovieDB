//
//  SettingsViewController.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 16.03.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark mode ON"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let themeSwitch: UISwitch = {
        let themeSwitch = UISwitch()
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        return themeSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        setupUI()
        loadSettings()
        
        themeSwitch.addTarget(self, action: #selector(didChangeTheme), for: .valueChanged)
    }
    
    private func setupUI() {
        view.addSubview(themeLabel)
        view.addSubview(themeSwitch)
        
        NSLayoutConstraint.activate([
            themeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            themeSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            themeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func loadSettings() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        themeSwitch.isOn = isDarkMode
    }
    
    @objc private func didChangeTheme() {
        let isDarkMode = themeSwitch.isOn
        UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        NotificationCenter.default.post(name: NSNotification.Name("themeChanged"), object: nil)
    }
}
