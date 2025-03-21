//
//  RealmService.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 16.03.2025.
//

import RealmSwift

final class RealmService {
    
    static let shared = RealmService()
    
    private var realm: Realm? {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            return try Realm(configuration: config)
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
    private init() {}
    
    func saveMovie(_ movie: Movie) {
        guard let realm = realm else { return }
        
        let realmMovie = RealmMovie(movie: movie)
        do {
            try realm.write {
                realm.add(realmMovie, update: .modified)
            }
            print("Movie saved to Realm: \(movie.title)")
        } catch {
            print("Failed to save movie to Realm: \(error.localizedDescription)")
        }
    }
    
    func getMovies() -> [Movie] {
        guard let realm = realm else { return [] }
        let realmMovies = realm.objects(RealmMovie.self)
        return realmMovies.map { Movie(from: $0) }
    }
    
    func deleteMovie(_ movie: Movie) {
        guard let realm = realm else { return }
        
        if let object = realm.object(ofType: RealmMovie.self, forPrimaryKey: movie.id) {
            do {
                try realm.write {
                    realm.delete(object)
                }
                print("Movie deleted from Realm: \(movie.title)")
            } catch {
                print("Failed to delete movie from Realm: \(error.localizedDescription)")
            }
        }
    }
    
    func isMovieSaved(_ movieID: Int) -> Bool {
        guard let realm = realm else { return false }
        return realm.object(ofType: RealmMovie.self, forPrimaryKey: movieID) != nil
    }
}
