//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 05.11.2022.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    // MARK: - Variables
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Methods
    func present(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: { _ in
            model.completion()
        })
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "alertOfResult"
        viewController?.present(alert, animated: true)
    }
}
