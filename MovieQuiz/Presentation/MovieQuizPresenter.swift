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
        didAnswer(isYes: false)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
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
    
    func showNextQuestionOrResults() {
        if self.isLastIndex() {
            guard let viewController = viewController else { return }
            viewController.statisticService.store(correct: viewController.correctAnswers, total: self.questionsAmount)
            let text = """
Ваш результат: \(viewController.correctAnswers) из 10
Количество сыграных квизов: \(viewController.statisticService.gamesCount)
Рекорд: \(viewController.statisticService.bestGame.correct ) /\(viewController.statisticService.bestGame.total) (\(viewController.statisticService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", viewController.statisticService.totalAccuracy))%
"""
            let alertModel: AlertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз") { [weak self] in
                    guard let self = self  else { return nil }
                    self.resetQuestionIndex()
                    return viewController.questionFactory?.requestNextQuestion()
                }
            viewController.alertPresenter?.present(model: alertModel)
            viewController.correctAnswers = 0
        } else {
            self.switchToNextQuestion()
            viewController?.questionFactory?.requestNextQuestion()
        }
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            //Отличается от варианта из курса из-за отличий в изначально созданном файле
            guard let currentQuestion = self?.currentQuestion, let self = self else { return }
            self.viewController?.showQuestion(quiz: (self.convert(model: currentQuestion)))
        }
    }
    
}

