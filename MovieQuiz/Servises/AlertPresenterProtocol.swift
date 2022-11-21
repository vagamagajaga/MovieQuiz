//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Vagan Galstian on 11.11.2022.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func present(model: AlertModel)
}
