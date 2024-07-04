//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 31.10.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func getMovie() -> MostPopularMovie?
    func loadData()
    func getTrailerLink(completion: @escaping (String?) -> Void)
}
