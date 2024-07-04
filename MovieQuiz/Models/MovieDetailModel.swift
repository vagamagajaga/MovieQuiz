//
//  MovieDetailModel.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 03.07.2024.
//

import Foundation

struct MoviesDetailModel: Codable {
    let errorMessage, link, linkEmbed: String

    enum CodingKeys: String, CodingKey {
        case errorMessage, link, linkEmbed
    }
}
