//
//  MostPopularMovie.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 26.11.2022.
//

import Foundation

struct MostPopularMovies: Decodable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Decodable {
    let title: String
    let rank: String
    let imageURL: URL
    
    var resizedImageURL: URL {
            let urlString = imageURL.absoluteString
            let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
            guard let newURL = URL(string: imageUrlString) else {
                return imageURL
            }
            return newURL
        }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rank = "imDbRating"
        case imageURL = "image"
    }
}
