//
//  APIService.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import Foundation
import Combine

final class APIService {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "8fc6d6a46ad2e1bfaf723c3dff805646"
    static let accessToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4ZmM2ZDZhNDZhZDJlMWJmYWY3MjNjM2RmZjgwNTY0NiIsIm5iZiI6MTc0MDM4Nzc3NS4zOCwic3ViIjoiNjdiYzM1YmZkMzYzMTY5NDY2NDY5MDVkIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.KciC8Nr70jskL206Cuw8XTSUUbB58_abxUKb0zxqg1E"

        private var cancellables = Set<AnyCancellable>()

// MARK: - Movie API endpoints
        enum MovieEndpoint {
            case popular
            case topRated
            case upcoming
            case search(query: String)
            case details(movieID: Int)
            case cast(movieID: Int)

            var urlString: String {
                switch self {
                case .popular:
                    return "\(APIService.baseURL)/movie/popular?api_key=\(APIService.apiKey)&language=en-US&page=1"
                case .topRated:
                    return "\(APIService.baseURL)/movie/top_rated?api_key=\(APIService.apiKey)&language=en-US&page=1"
                case .upcoming:
                    return "\(APIService.baseURL)/movie/upcoming?api_key=\(APIService.apiKey)&language=en-US&page=1"
                case .search(let query):
                    return "\(APIService.baseURL)/search/movie?api_key=\(APIService.apiKey)&language=en-US&query=\(query)"
                case .details(let movieID):
                    return "\(APIService.baseURL)/movie/\(movieID)?api_key=\(APIService.apiKey)&language=en-US"
                case .cast(let movieID):
                    return "\(APIService.baseURL)/movie/\(movieID)/credits?api_key=\(APIService.apiKey)&language=en-US"
                }
            }
        }

// MARK: - Fetch movies
        func fetchMovies(from endpoint: MovieEndpoint) -> AnyPublisher<[Movie], Error> {
            performMoviesRequest(urlString: endpoint.urlString)
        }

// MARK: - Fetch movie details
        func fetchMovieDetail(movieID: Int) -> AnyPublisher<MovieDetail, Error> {
            performRequest(urlString: MovieEndpoint.details(movieID: movieID).urlString)
        }

// MARK: - Fetch movie cast
        func fetchMovieCast(movieID: Int) -> AnyPublisher<[Actor], Error> {
            performCastRequest(urlString: MovieEndpoint.cast(movieID: movieID).urlString)
        }

// MARK: - Generic API request for movie lists
        private func performMoviesRequest(urlString: String) -> AnyPublisher<[Movie], Error> {
            request(urlString: urlString)
                .decode(type: MoviesResponse.self, decoder: JSONDecoder())
                .map { $0.results }
                .eraseToAnyPublisher()
        }

// MARK: - Generic API request for single object (MovieDetail)
        private func performRequest<T: Decodable>(urlString: String) -> AnyPublisher<T, Error> {
            request(urlString: urlString)
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }

// MARK: - Generic API request for movie cast
        private func performCastRequest(urlString: String) -> AnyPublisher<[Actor], Error> {
            request(urlString: urlString)
                .decode(type: CastResponse.self, decoder: JSONDecoder())
                .map { $0.cast }
                .eraseToAnyPublisher()
        }

// MARK: - Common network request handler
        private func request(urlString: String) -> AnyPublisher<Data, Error> {
            guard let url = URL(string: urlString) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(APIService.accessToken, forHTTPHeaderField: "Authorization")

            return URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.data }
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
    }
