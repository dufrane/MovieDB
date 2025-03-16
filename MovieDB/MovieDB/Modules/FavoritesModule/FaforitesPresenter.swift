//
//  FaforitesPresenter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 10.03.2025.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectMovie(_ movie: Movie)
}

final class FavoritesPresenter: FavoritesPresenterProtocol {

    var view: FavoritesViewProtocol? // 👈 Без weak!
    private let interactor: FavoritesInteractorProtocol
    private let router: FavoritesRouterProtocol

    init(interactor: FavoritesInteractorProtocol, router: FavoritesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchFavoriteMovies { [weak self] movies in
            self?.view?.showFavorites(movies)
        }
    }

    func didSelectMovie(_ movie: Movie) {
        router.navigateToMovieDetail(movie: movie)
    }
}


