//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 13.11.2022.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func didRecieveAlertPresenter(result: AlertModel?)
}
