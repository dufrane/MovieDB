//
//  ConfigurationModel.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 24.02.2025.
//

import Foundation

struct Configuration: Decodable {
    let images: ImagesConfig
}

struct ImagesConfig: Decodable {
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
    let stillSizes: [String]
}

