//
//  MoviesResponse.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]
}
