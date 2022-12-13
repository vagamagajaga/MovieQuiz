//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 13.12.2022.
//

import UIKit

final class MovieQuizPresenter {
    
    weak var viewController: MovieQuizViewController?
    var currentQuestion: QuizQuestion?
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Actions
    func noButtonClicked() {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func yesButtonClicked() {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Methods
    func isLastIndex() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
}

