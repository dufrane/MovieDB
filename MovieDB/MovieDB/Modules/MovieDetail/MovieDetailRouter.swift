//
//  MovieDetailRouter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 12.03.2025.
//

import Foundation

protocol MovieDetailRouterProtocol: AnyObject {
    func closeDetail()
}

final class MovieDetailRouter: MovieDetailRouterProtocol {
    func closeDetail() {
        print("Closing detail screen")
    }
}
