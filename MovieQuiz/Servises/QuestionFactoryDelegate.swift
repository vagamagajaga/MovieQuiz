//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 31.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
