//
//  MoviesBuilder.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import UIKit

final class MoviesBuilder {
    static func build(coordinator: MoviesCoordinator) -> MoviesViewController {
        let viewModel = MoviesViewModel(coordinator: coordinator)
        let viewController = MoviesViewController(viewModel: viewModel)
        return viewController
    }
}

