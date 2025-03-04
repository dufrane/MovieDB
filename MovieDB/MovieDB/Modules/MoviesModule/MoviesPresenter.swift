//
//  MoviesPresenter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 06.03.2025.
//

import Foundation

protocol MoviesPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didSelectMovie(_ movie: Movie)
    func searchMovies(query: String)
    func fetchMovies(by category: APIService.MovieEndpoint)
}

final class MoviesPresenter {
    
    weak var view: MoviesViewProtocol?
    var interactor: MoviesInteractorProtocol
    var router: MoviesRouterProtocol
    
    init(interactor: MoviesInteractorProtocol, router: MoviesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}


extension MoviesPresenter: MoviesPresenterProtocol {
    
    func viewDidLoaded() {
        fetchMovies(by: .popular)
    }
    
    func didSelectMovie(_ movie: Movie) {
        router.navigateToMovieDetail(movie: movie)
    }
    
    func searchMovies(query: String) {
        interactor.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.view?.showMovies(movies)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func fetchMovies(by category: APIService.MovieEndpoint) {
        interactor.fetchMovies(from: category) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.view?.showMovies(movies)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
}
