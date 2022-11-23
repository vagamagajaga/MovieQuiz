//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 20.11.2022.
//

import Foundation
import UIKit

final class StatisticServiceImplementation: StatisticServiceProtocol {
    // MARK: - Keys
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    // MARK: - Constants
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Variables
    var totalAccuracy: Double {
        Double(userDefaults.integer(forKey: Keys.correct.rawValue)) /
        Double(userDefaults.integer(forKey: Keys.total.rawValue)) * 100
    }

    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let total = try? JSONDecoder().decode(Int.self, from: data) else {
                      return 0
                  }
            return total
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно увеличить количество игр")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    // MARK: - Methods
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        userDefaults.set(userDefaults.integer(forKey: "correct") + count, forKey: "correct")
        userDefaults.set(userDefaults.integer(forKey: "total") + amount, forKey: "total")
        if currentGame > bestGame {
            bestGame = currentGame
        }
    }
}
