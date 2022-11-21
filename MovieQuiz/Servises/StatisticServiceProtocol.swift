//
//  StatisticServiceProtokol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 20.11.2022.
//

import Foundation

//MARK: - Protocol

protocol StatisticServiceProtocol: AnyObject {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
