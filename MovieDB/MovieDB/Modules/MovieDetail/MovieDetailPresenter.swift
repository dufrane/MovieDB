//
//  MovieDetailPresenter.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 10.03.2025.
//

import Foundation

protocol MovieDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class MovieDetailPresenter: MovieDetailPresenterProtocol {

    weak var view: MovieDetailViewProtocol?
    private let interactor: MovieDetailInteractorProtocol
    private let movieID: Int

    init(interactor: MovieDetailInteractorProtocol, movieID: Int) {
        self.interactor = interactor
        self.movieID = movieID
    }

    func viewDidLoad() {
        interactor.fetchMovieDetail(movieID: movieID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.view?.showMovieDetail(detail)
                case .failure(let error):
                    print(" Failed to load details:", error)
                }
            }
        }
        
        interactor.fetchMovieCast(movieID: movieID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cast):
                    self?.view?.showCast(cast)
                case .failure(let error):
                    print(" Failed to load cast:", error)
                }
            }
        }
    }
}
