//
//  FavoritesService.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import CoreData

final class FavoritesService {
    static let shared = FavoritesService()
    
    private let context = CoreDataStack.shared.context

// MARK: - Add to favorites
    func addMovieToFavorites(movie: Movie) {
        let favorite = FavoriteMovie(context: context)
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.posterPath = movie.posterPath ?? ""

        saveContext()
    }

// MARK: - Get favorites
    func fetchFavoriteMovies() -> [FavoriteMovie] {
        let request = FavoriteMovie.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return []
        }
    }

// MARK: - Remove from favorite
    func removeMovieFromFavorites(movieID: Int) {
        let request = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error removing favorite movie: \(error.localizedDescription)")
        }
    }

// MARK: - Check is favorite
    func isMovieFavorite(movieID: Int) -> Bool {
        let request = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking favorite status: \(error.localizedDescription)")
            return false
        }
    }

// MARK: - Save to CoreData
    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}
