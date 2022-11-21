//
//  GameRecord + Extensions.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 20.11.2022.
//

import Foundation

extension GameRecord: Comparable {
    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct == rhs.correct
    }
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
}
