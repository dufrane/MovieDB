//
//  MoviesPresenter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 06.03.2025.
//

import Foundation

protocol MoviesPresenterProtocol {
    func fetchMovies(from category: APIService.MovieEndpoint)
    func searchMovies(query: String)
    func toggleFavorite(movie: Movie)
    func didSelectMovie(movie: Movie)
    func resetPagination()
    
    var hasMorePages: Bool { get }
    var isLoading: Bool { get }
}


final class MoviesPresenter: MoviesPresenterProtocol {

    weak var view: MoviesViewProtocol?
    private let interactor: MoviesInteractorProtocol
    private let router: MoviesRouterProtocol
    private var movies: [Movie] = []
    private var currentPage = 1
    private(set) var hasMorePages = true
    private(set) var isLoading = false

    init(view: MoviesViewProtocol, interactor: MoviesInteractorProtocol, router: MoviesRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func resetPagination() {
        currentPage = 1
        hasMorePages = true
        isLoading = false
        movies.removeAll()
        view?.showMovies(movies)
    }
    
    func fetchMovies(from category: APIService.MovieEndpoint) {
        guard !isLoading, hasMorePages else { return }
        isLoading = true
        print("Requesting page: \(currentPage)")
        
        interactor.fetchMovies(from: category, page: currentPage) { [weak self] (result: Result<[Movie], Error>) in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let movies):
                guard !movies.isEmpty else {
                    self.hasMorePages = false
                    return
                }
                
                self.currentPage += 1
                let updatedMovies = movies.map { movie -> Movie in
                    var updatedMovie = movie
                    updatedMovie.isFavorite = RealmService.shared.isMovieSaved(movie.id)
                    return updatedMovie
                }
                self.movies.append(contentsOf: updatedMovies)
                self.view?.showMovies(self.movies)
                
            case .failure(let error):
                print("Failed to load movies: \(error.localizedDescription)")
            }
        }
    }


    func searchMovies(query: String) {
        interactor.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                let updatedMovies = movies.map { movie -> Movie in
                    var updatedMovie = movie
                    updatedMovie.isFavorite = self?.interactor.isMovieFavorite(movieID: movie.id) ?? false
                    return updatedMovie
                }
                
                self?.movies = updatedMovies
                self?.view?.showMovies(updatedMovies)
                
            case .failure(let error):
                print("Failed to search movies: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleFavorite(movie: Movie) {
        if interactor.isMovieFavorite(movieID: movie.id) {
            interactor.removeMovieFromFavorites(movieID: movie.id)
        } else {
            interactor.addMovieToFavorites(movie: movie)
        }

        movies = movies.map { item -> Movie in
            var updatedItem = item
            if item.id == movie.id {
                updatedItem.isFavorite = RealmService.shared.isMovieSaved(movie.id)
            }
            return updatedItem
        }

        view?.showMovies(movies)
    }

    func didSelectMovie(movie: Movie) {
        router.navigateToMovieDetail(movie: movie)
    }
}
