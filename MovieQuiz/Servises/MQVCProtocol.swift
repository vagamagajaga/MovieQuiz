//
//  MQVCProtocol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 14.12.2022.
//

import Foundation

protocol MQVCProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func highlightImageBorder(isCorrect: Bool)    
    func showQuestion(quiz step: QuizStepViewModel)
    func setButtonsEnabled(_ enabled: Bool)
    func present(model: AlertModel)
}
