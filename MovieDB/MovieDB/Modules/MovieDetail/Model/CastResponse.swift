//
//  CastResponse.swift
//  MovieDB
//
//  Created by Dmytro Vasylenko on 25.02.2025.
//

import Foundation

struct CastResponse: Decodable {
    let cast: [Actor]
}
