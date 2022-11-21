//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 20.11.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

