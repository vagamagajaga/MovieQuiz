//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 05.11.2022.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    var alertController: UIAlertController
    
    func present(alert: AlertModel) {
        //тут я так понимаю. мы должны вернуть alertController, собрав его перед этим
    }
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
}
    
    
    
    
    
    
    
    
    
    

