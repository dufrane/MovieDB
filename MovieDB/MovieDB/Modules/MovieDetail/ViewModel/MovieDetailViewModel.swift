//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {
    var coordinator: MovieDetailCoordinatorProtocol
    private let apiService: APIService
    private var cancellables = Set<AnyCancellable>()

    @Published var movieDetail: MovieDetail? {
        didSet {
            print("Movie Detail Loaded:", movieDetail ?? "No Data")
        }
    }
    @Published var cast: [Actor] = []
    @Published var errorMessage: String?

    init(coordinator: MovieDetailCoordinatorProtocol, apiService: APIService) {
        self.coordinator = coordinator
        self.apiService = apiService
    }

    func fetchMovieDetail(movieID: Int) {
        apiService.fetchMovieDetail(movieID: movieID)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error loading movie details:", error.localizedDescription)
                }
            }, receiveValue: { [weak self] detail in
                self?.movieDetail = detail
            })
            .store(in: &cancellables)
    }


    func fetchMovieCast(movieID: Int) {
        apiService.fetchMovieCast(movieID: movieID)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] cast in
                self?.cast = cast
            })
            .store(in: &cancellables)
    }

    func closeDetailScreen() {
        coordinator.closeMovieDetail()
    }
}
