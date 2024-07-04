//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 05.11.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel, isNeedCancel: Bool) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        let cancelAction = UIAlertAction(title: "Назад", style: .cancel)
        
        if isNeedCancel { alert.addAction(action) }
        alert.addAction(cancelAction)
        delegate?.present(alert, animated: true)
    }
}
