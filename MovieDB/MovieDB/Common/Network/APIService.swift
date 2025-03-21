//
//  APIService.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import Foundation

final class APIService {
    static let baseURL = "https://api.themoviedb.org/3"
    private let keychainService = KeychainService()
    
    private var apiKey: String? {
        return keychainService.getAPIKey()
    }
    
    // MARK: - Movie API Endpoints
    enum MovieEndpoint {
        case popular
        case topRated
        case upcoming
        case search(query: String)
        case details(movieID: Int)
        case cast(movieID: Int)
        
        var path: String {
            switch self {
            case .popular: return "/movie/popular"
            case .topRated: return "/movie/top_rated"
            case .upcoming: return "/movie/upcoming"
            case .search: return "/search/movie"
            case .details(let movieID): return "/movie/\(movieID)"
            case .cast(let movieID): return "/movie/\(movieID)/credits"
            }
        }
        
        func queryItems(query: String? = nil, page: Int = 1) -> [URLQueryItem] {
            var items: [URLQueryItem] = [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            if let query = query, !query.isEmpty {
                items.append(URLQueryItem(name: "query", value: query))
            }
            return items
        }
    }
    
    // MARK: - Fetch Movies
    func fetchMovies(from endpoint: MovieEndpoint, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        request(endpoint: endpoint, page: page, responseType: MoviesResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Fetch Movie Details
    func fetchMovieDetail(movieID: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        request(endpoint: .details(movieID: movieID), page: 1, responseType: MovieDetail.self, completion: completion)
    }
    
    // MARK: - Fetch Movie Cast
    func fetchMovieCast(movieID: Int, completion: @escaping (Result<[Actor], Error>) -> Void) {
        request(endpoint: .cast(movieID: movieID), page: 1, responseType: CastResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.cast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Generic API Request
    private func request<T: Decodable>(endpoint: MovieEndpoint, page: Int = 1, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let apiKey = apiKey else {
            completion(.failure(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "API Key missing"])))
            return
        }
        
        guard var components = URLComponents(string: APIService.baseURL + endpoint.path) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        if case .search(let query) = endpoint {
            components.queryItems = endpoint.queryItems(query: query, page: page)
        } else {
            components.queryItems = endpoint.queryItems(page: page)
        }
        
        guard let url = components.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    print("Server responded with status code: \(statusCode)")
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    print("JSON Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
