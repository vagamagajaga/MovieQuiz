//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 31.10.2022.
//
import Foundation

protocol QuestionFactoryDelegate: AnyObject {                   // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}
