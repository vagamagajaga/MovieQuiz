//
//  PresenterTests.swift
//  PresenterTests
//
//  Created by Vagan Galstian on 14.12.2022.
//


import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MQVCProtocol {
    func setButtonsEnabled(_ enabled: Bool) { }
    func showLoadingIndicator() { }
    func hideLoadingIndicator() { }
    func showNetworkError(message: String) { }
    func highlightImageBorder(isCorrect: Bool) { }
    func showQuestion(quiz step: QuizStepViewModel) { }
    func presentAlert(model: AlertModel) { }
}

final class PresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sample = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sample.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
        
    }
}
