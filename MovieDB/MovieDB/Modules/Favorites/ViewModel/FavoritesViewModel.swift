//
//  FavoritesViewModel.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

//import Combine
//
//final class FavoritesViewModel: ObservableObject {
//    private let favoritesService = FavoritesService()
//    private let coordinator: FavoritesCoordinatorProtocol
//
//    @Published var favoriteMovies: [FavoriteMovie] = []
//    var cancellables = Set<AnyCancellable>()
//
//    init(coordinator: FavoritesCoordinatorProtocol) {
//        self.coordinator = coordinator
//    }
//
//    func fetchFavorites() {
//        favoriteMovies = favoritesService.fetchFavoriteMovies()
//    }
//
//    func didSelectMovie(movie: FavoriteMovie) {
//        coordinator.showMovieDetail(movie: movie)
//    }
//}
