//
//  MostPopularMovie.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 26.11.2022.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [Movie]
}

struct Movie: Codable {
    let title: String
    let rank: Double
    let imageURL: URL
    
    
    private enum CodingKeys: String, CodingKey {
        case title = "FullTitle"
        case rank = "imDbRating"
        case imageURL = "image"
    }
}
